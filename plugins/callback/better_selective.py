# -*- coding: utf-8 -*-
# Copyright (c) Fastly, inc 2016
# Copyright (c) 2017 Ansible Project
# Copyright (c) 2024 Sandorex
# GNU General Public License v3.0+ (see LICENSES/GPL-3.0-or-later.txt or https://www.gnu.org/licenses/gpl-3.0.txt)
# SPDX-License-Identifier: GPL-3.0-or-later

from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = '''
    author: Unknown (!UNKNOWN)
    name: better_selective
    type: stdout
    requirements:
      - set as main display callback
    short_description: hide certain tasks
    description:
      - This callback prints all tasks by default but allows you to selectively hide them,
        to hide a task add an underscore C(_) at start of the name of the task
      - Failed tasks if C(ignore_errors) is not enabled
      - All tasks will be printed if verbosity is increased
      - Tasks that are not printed are replaced with a C(.).
    options:
      nocolor:
        default: false
        description: This setting allows suppressing colorizing output.
        env:
          - name: ANSIBLE_NOCOLOR
          - name: ANSIBLE_SELECTIVE_DONT_COLORIZE
        ini:
          - section: defaults
            key: nocolor
        type: boolean
'''

EXAMPLES = """
  - name: _Message
    ansible.builtin.debug:
        msg="This will not be printed"
  - ansible.builtin.debug:
        msg="But this will"
"""

import difflib

from ansible import constants as C
from ansible.plugins.callback import CallbackBase
from ansible.module_utils.common.text.converters import to_text


DONT_COLORIZE = False
COLORS = {
    'normal': '\033[0m',
    'ok': '\033[{0}m'.format(C.COLOR_CODES[C.COLOR_OK]),
    'bold': '\033[1m',
    'not_so_bold': '\033[1m\033[34m',
    'changed': '\033[{0}m'.format(C.COLOR_CODES[C.COLOR_CHANGED]),
    'failed': '\033[{0}m'.format(C.COLOR_CODES[C.COLOR_ERROR]),
    'endc': '\033[0m',
    'skipped': '\033[{0}m'.format(C.COLOR_CODES[C.COLOR_SKIP]),
}


def dict_diff(prv, nxt):
    """Return a dict of keys that differ with another config object."""
    keys = set(list(prv.keys()) + list(nxt.keys()))
    result = {}
    for k in keys:
        if prv.get(k) != nxt.get(k):
            result[k] = (prv.get(k), nxt.get(k))
    return result


def colorize(msg, color):
    """Given a string add necessary codes to format the string."""
    if DONT_COLORIZE:
        return msg
    else:
        return '{0}{1}{2}'.format(COLORS[color], msg, COLORS['endc'])


class CallbackModule(CallbackBase):
    """better_selective.py callback plugin."""

    CALLBACK_VERSION = 1.0
    CALLBACK_TYPE = 'stdout'
    CALLBACK_NAME = 'io.github.sandorex.better_selective'

    def __init__(self, display=None):
        """selective.py callback plugin."""
        super(CallbackModule, self).__init__(display)
        self.last_skipped = False
        self.last_task_name = None
        self.printed_last_task = False

    def set_options(self, task_keys=None, var_options=None, direct=None):

        super(CallbackModule, self).set_options(task_keys=task_keys, var_options=var_options, direct=direct)

        global DONT_COLORIZE
        DONT_COLORIZE = self.get_option('nocolor')

    def _print_task(self, task_name=None):
        if task_name is None:
            task_name = self.last_task_name

        if not self.printed_last_task:
            self.printed_last_task = True
            line_length = 120
            if self.last_skipped:
                print()
            line = "{0} ".format(task_name)
            msg = colorize(line, 'bold')
            print(msg)

    def _indent_text(self, text, indent_level):
        lines = text.splitlines()
        result_lines = []
        for l in lines:
            result_lines.append("{0}{1}".format(' ' * indent_level, l))
        return '\n'.join(result_lines)

    def _print_diff(self, diff, indent_level):
        if isinstance(diff, dict):
            try:
                diff = '\n'.join(difflib.unified_diff(diff['before'].splitlines(),
                                                      diff['after'].splitlines(),
                                                      fromfile=diff.get('before_header',
                                                                        'new_file'),
                                                      tofile=diff['after_header']))
            except AttributeError:
                diff = dict_diff(diff['before'], diff['after'])
        if diff:
            diff = colorize(str(diff), 'changed')
            print(self._indent_text(diff, indent_level + 4))

    def _print_host_or_item(self, host_or_item, changed, msg, diff, is_host, error, stdout, stderr):
        if is_host:
            indent_level = 0
            if host_or_item.name == "localhost":
                name = ""
            else:
                name = colorize(host_or_item.name + " ", 'not_so_bold')
        else:
            indent_level = 4
            if isinstance(host_or_item, dict):
                if 'key' in host_or_item.keys():
                    host_or_item = host_or_item['key']
            name = colorize(to_text(host_or_item), 'bold')

        if error:
            color = 'failed'
            change_string = colorize('FAILED!!!', color)
        else:
            color = 'changed' if changed else 'ok'
            if changed:
                change_string = colorize("CHANGED", color)
            else:
                change_string = ""

        if msg or change_string:
            msg = colorize(msg, color)
            print("{0}  {1}{2} {3}".format(' ' * indent_level, name, change_string, msg))

        if diff:
            self._print_diff(diff, indent_level)
        if stdout:
            stdout = colorize(stdout, 'failed')
            print(self._indent_text(stdout, indent_level + 6))
        if stderr:
            stderr = colorize(stderr, 'failed')
            print(self._indent_text(stderr, indent_level + 6))

    def v2_playbook_on_play_start(self, play):
        """Run on start of the play."""
        pass

    def v2_playbook_on_task_start(self, task, **kwargs):
        """Run when a task starts."""
        self.last_task_name = task.get_name()
        self.printed_last_task = False

    def _print_task_result(self, result, error=False, **kwargs):
        """Run when a task finishes correctly."""

        # print tasks that fulfill one of following criteria:
        # 1. the name does not start with _ underscore
        # 2. the task errors out but ignore_errors is not set!
        # 3. verbosity is higher than 1
        if not result._task.name.startswith("_") or (error and not result._task.ignore_errors) or self._display.verbosity > 0:
            self._print_task()
            self.last_skipped = False
            msg = to_text(result._result.get('msg', '')) or \
                to_text(result._result.get('reason', ''))

            stderr = [result._result.get('exception', None),
                      result._result.get('module_stderr', None)]
            stderr = "\n".join([e for e in stderr if e]).strip()

            self._print_host_or_item(result._host,
                                     result._result.get('changed', False),
                                     msg,
                                     result._result.get('diff', None),
                                     is_host=True,
                                     error=error,
                                     stdout=result._result.get('module_stdout', None),
                                     stderr=stderr.strip(),
                                     )
            if 'results' in result._result:
                for r in result._result['results']:
                    failed = 'failed' in r and r['failed']

                    stderr = [r.get('exception', None), r.get('module_stderr', None)]
                    stderr = "\n".join([e for e in stderr if e]).strip()

                    self._print_host_or_item(r['item'],
                                             r.get('changed', False),
                                             to_text(r.get('msg', '')),
                                             r.get('diff', None),
                                             is_host=False,
                                             error=failed,
                                             stdout=r.get('module_stdout', None),
                                             stderr=stderr.strip(),
                                             )
        else:
            # i do not need the dots
            pass
#            self.last_skipped = True
#            print('.', end="")

    def v2_playbook_on_stats(self, stats):
        """Display info about playbook statistics."""
        print()
        self.printed_last_task = False
        self._print_task('STATS')

        hosts = sorted(stats.processed.keys())
        for host in hosts:
            s = stats.summarize(host)

            if s['failures'] or s['unreachable']:
                color = 'failed'
            elif s['changed']:
                color = 'changed'
            else:
                color = 'ok'

            msg = '{0}    : ok={1}\tchanged={2}\tfailed={3}\tunreachable={4}\trescued={5}\tignored={6}'.format(
                host, s['ok'], s['changed'], s['failures'], s['unreachable'], s['rescued'], s['ignored'])
            print(colorize(msg, color))

    def v2_runner_on_skipped(self, result, **kwargs):
        """Run when a task is skipped."""
        if self._display.verbosity > 1:
            self._print_task()
            self.last_skipped = False

            line_length = 120
            spaces = ' ' * (31 - len(result._host.name) - 4)

            line = "  * {0}{1}- {2}".format(colorize(result._host.name, 'not_so_bold'),
                                            spaces,
                                            colorize("skipped", 'skipped'),)

            reason = result._result.get('skipped_reason', '') or \
                result._result.get('skip_reason', '')
            if len(reason) < 50:
                line += ' -- {0}'.format(reason)
                print("{0} {1}---------".format(line, '-' * (line_length - len(line))))
            else:
                print("{0} {1}".format(line, '-' * (line_length - len(line))))
                print(self._indent_text(reason, 8))
                print(reason)

    def v2_runner_on_ok(self, result, **kwargs):
        self._print_task_result(result, error=False, **kwargs)

    def v2_runner_on_failed(self, result, **kwargs):
        self._print_task_result(result, error=True, **kwargs)

    def v2_runner_on_unreachable(self, result, **kwargs):
        self._print_task_result(result, error=True, **kwargs)

    v2_playbook_on_handler_task_start = v2_playbook_on_task_start
