function getPostDetails(element, post_id) {
    var post_wrapper = element.parentNode.parentNode;
    var post_details = post_wrapper.getElementsByClassName("post_details")[0];
    if(post_details == null) {
        element.innerHTML = STR_LOADING;
        // send ajax to get price and lat lng
        var query =
            `query {
                    post(id: ` + post_id + `) {
                    description
                    image_urls
                    contact_name
                    contact_phone
                    contact_email
                    contact_address
                }
            } `;
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                var post = JSON.parse(this.responseText).data.post;
                var image_urls = post.image_urls;
                var description = post.description;
                var contact_name = post.contact_name;
                var contact_phone = post.contact_phone;
                var contact_email = post.contact_email;
                var contact_address = post.contact_address;

                if(contact_name == null || contact_name == "") {
                    contact_name = STR_UNKNOWN;
                }
                if(contact_phone == null || contact_phone == "") {
                    contact_phone = STR_UNKNOWN;
                }
                if(contact_email == null || contact_email == "") {
                    contact_email = STR_UNKNOWN;
                }
                if(contact_address == null || contact_address == "") {
                    contact_address = STR_UNKNOWN;
                }

                var divNodeDetails = document.createElement("div");
                divNodeDetails.setAttribute("class", "post_details");
                divNodeDetails.setAttribute("id", "post_details_" + post_id);

                var divNodeImg = document.createElement("div");
                divNodeImg.setAttribute("class", "post_photo tab-photo");
                // divNodeImg.setAttribute("id", "post_photo_" + post_id);
                divNodeDetails.appendChild(divNodeImg);

                var divNodeContent = document.createElement("div");
                divNodeContent.setAttribute("class", "post_content");
                // divNodeContent.setAttribute("id", "post_content_" +
				// post_id);
                divNodeDetails.appendChild(divNodeContent);

                var divNodeContact = document.createElement("div");
                divNodeContact.setAttribute("class", "post_contact");
                // divNodeContact.setAttribute("id", "post_contact_" +
				// post_id);
                divNodeDetails.appendChild(divNodeContact);

                post_wrapper.appendChild(divNodeDetails);

                showSlide(image_urls, divNodeImg, post_id);
                divNodeContent.innerHTML = description;

                var data = "<div class='contact_label'>" + STR_CONTACT_LANDLORD + "</div>";
                data = data + "<div class='contact_info'><i class='color-blue fa fa-user'></i> " + contact_name + "</div>";
                data = data + "<div class='contact_info'><i class='color-blue fa fa-phone'></i> " + contact_phone + "</div>";
                data = data + "<div class='contact_info'><i class='color-blue fa fa-envelope-square'></i> " + contact_email + "</div>";
                data = data + "<div class='contact_info'><i class='color-blue fa fa-home'></i> " + contact_address + "</div>";
                divNodeContact.innerHTML = data;

                element.innerHTML = STR_HIDE_DETAILS;
            }
        };
        xhttp.open("GET", "/graphql?query=" + escape(query), true);
        xhttp.setRequestHeader("Content-Type", "application/json; charset=UTF-8");
        xhttp.send();
    } else {
        if(post_details.style.display != 'none') {
            $("#post_details_" + post_id).hide(300);
            element.innerHTML = STR_VIEW_DETAILS;
        } else {
            $("#post_details_" + post_id).show(300);
            element.innerHTML = STR_HIDE_DETAILS;
        }
    }
}