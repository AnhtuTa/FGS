
/** Defines the Popup class. */
function definePopupClass() {
    /**
     * A customized popup on the map.
     * @param {!google.maps.LatLng} position
     * @param {!Element} content
     * @param {String} color_of_after màu của after của popup. Do popup được tạo ra sẽ có 1 hình tam giác để chỉ vào vị
     * trí mà nó neo. Cái hình tam giác này được vẽ = popup-bubble-anchor::after.
     * Do đó nếu muốn thay đổi màu cho hình tam giác này thì ta cần thêm 1 class nữa để thay đổi màu
     * Nếu tham số này = null thì màu của hình tam giác đó sẽ được thiết lập trong file .css với class: popup-bubble-anchor::after
     * Nhưng nếu ta thêm 1 class khác để chỉ rõ màu của nó, chẳng hạn tên là after-red, thì màu của hình tam giác này
     * sẽ được thiết lập ở class after-red::after
     * @constructor
     * @extends {google.maps.OverlayView}
     */
    Popup = function (position, content, color_of_after=null) {
        this.position = position;

        content.classList.add('popup-bubble-content');

        var pixelOffset = document.createElement('div');
        pixelOffset.classList.add('popup-bubble-anchor');
        if(color_of_after != null) {
            pixelOffset.classList.add('after-' + color_of_after);
            console.log("add after-red");
        }
        pixelOffset.appendChild(content);

        this.anchor = document.createElement('div');
        this.anchor.classList.add('popup-tip-anchor');
        this.anchor.appendChild(pixelOffset);

        // Optionally stop clicks, etc., from bubbling up to the map.
        this.stopEventPropagation();
    };
    // NOTE: google.maps.OverlayView is only defined once the Maps API has
    // loaded. That is why Popup is defined inside initMap().
    Popup.prototype = Object.create(google.maps.OverlayView.prototype);

    /** Called when the popup is added to the map. */
    Popup.prototype.onAdd = function () {
        this.getPanes().floatPane.appendChild(this.anchor);
    };

    /** Called when the popup is removed from the map. */
    Popup.prototype.onRemove = function () {
        if (this.anchor.parentElement) {
            this.anchor.parentElement.removeChild(this.anchor);
        }
    };

    /** Called when the popup needs to draw itself. */
    Popup.prototype.draw = function () {
        var divPosition = this.getProjection().fromLatLngToDivPixel(this.position);
        // Hide the popup when it is far out of view.
        var display =
            Math.abs(divPosition.x) < 4000 && Math.abs(divPosition.y) < 4000 ?
                'block' :
                'none';

        if (display === 'block') {
            this.anchor.style.left = divPosition.x + 'px';
            this.anchor.style.top = divPosition.y + 'px';
        }
        if (this.anchor.style.display !== display) {
            this.anchor.style.display = display;
        }
    };

    /** Stops clicks/drags from bubbling up to the map. */
    Popup.prototype.stopEventPropagation = function () {
        var anchor = this.anchor;
        anchor.style.cursor = 'auto';

        ['click', 'dblclick', 'contextmenu', 'wheel', 'mousedown', 'touchstart',
            'pointerdown']
            .forEach(function (event) {
                anchor.addEventListener(event, function (e) {
                    e.stopPropagation();
                });
            });
    };
}
