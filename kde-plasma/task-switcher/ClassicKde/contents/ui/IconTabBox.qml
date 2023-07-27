/*
 KWin - the KDE window manager
 This file is part of the KDE project.

 SPDX-FileCopyrightText: 2011 Martin Gräßlin <mgraesslin@kde.org>

 SPDX-License-Identifier: GPL-2.0-or-later
 */
import QtQuick 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kquickcontrolsaddons 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: iconsTabBox
    function decrementCurrentIndex() {
        iconsListView.decrementCurrentIndex();
    }
    function incrementCurrentIndex() {
        iconsListView.incrementCurrentIndex();
    }
    property int iconSize
    property alias count: iconsListView.count
    property alias margins: hoverItem.margins
    property alias currentItem: iconsListView.currentItem
    property alias model: iconsListView.model
    property alias currentIndex: iconsListView.currentIndex
    focus: true
    clip: true

    // just to get the margin sizes
    PlasmaCore.FrameSvgItem {
        id: hoverItem
        imagePath: "widgets/viewitem"
        prefix: "hover"
        visible: false
    }

    // delegate
    Component {
        id: listDelegate
        Item {
            property alias caption: iconItem.caption
            id: delegateItem
            width: iconSize + PlasmaCore.Units.smallSpacing * 8
            height: width
            QIconItem {
                property variant caption: model.caption
                id: iconItem
                icon: model.icon
                width: iconSize
                height: iconSize
                state: QIconItem.DefaultState;
                anchors {
                    top: parent.top
                    topMargin: PlasmaCore.Units.smallSpacing * 2
                    horizontalCenter: parent.horizontalCenter
                    //verticalCenterOffset: -3*PlasmaCore.Units.smallSpacing
                    //verticalCenter: parent.verticalCenter
                }
            }

            PlasmaComponents.Label {
                id: textItem
                width: parent.width - PlasmaCore.Units.smallSpacing*2
                text: {
                    var program = (model.caption).split('—')[1]
                    return (program) ? program : (model.caption).split('-').pop()
                }
                height: paintedHeight
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                font.weight: iconsListView.currentIndex === index ? Font.Bold : Font.Normal
                anchors{
                    horizontalCenter: parent.horizontalCenter
                    bottom: parent.bottom
                    bottomMargin: PlasmaCore.Units.smallSpacing
                }
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    iconsListView.currentIndex = index;
                }
            }
        }
    }
    ListView {
        id: iconsListView
        orientation: ListView.Horizontal
        width: Math.min(parent.width, (iconSize + PlasmaCore.Units.smallSpacing * 8 ) * count)
        height: iconSize + PlasmaCore.Units.smallSpacing * 8
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }
        clip: true
        delegate: listDelegate
        highlight: PlasmaCore.FrameSvgItem {
            id: highlightItem
            imagePath: "widgets/viewitem"
            prefix: "hover"
            width: iconSize + PlasmaCore.Units.smallSpacing * 8
            height: width
        }
        
        highlightResizeDuration: 0
        highlightMoveDuration: 0
        focus: false
        boundsBehavior: Flickable.StopAtBounds
    }
}
