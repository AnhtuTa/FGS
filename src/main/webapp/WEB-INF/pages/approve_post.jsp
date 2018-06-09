<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ page isELIgnored="false" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>home</title>
    <link rel="shortcut icon" href="/img/favicon.png">
    <link rel='stylesheet' href="/css/style.css">
    <script type="text/javascript" src="/js/fgs.js"></script>
    <style type="text/css">
        .approve_post_item {
            border-radius: 4px;
            margin: 20px 0;
            background: #fbfbfb;
            padding: 10px;
        }
        .approve_post_item table {
            border-collapse: collapse;
            width: 100%;
        }
        .approve_post_item tr {

        }
        .approve_post_item td {
            padding: 5px;
        }
        .td_label {
            width: 125px;
            text-align: right;
            vertical-align: baseline;
        }
        .td_content {

        }
        .btn_decline {
            padding: 8px;
            border-radius: 4px;
            background: #e32727;
            border: 1px solid #e32727;
            color: #fff;
            font-weight: bold;
            cursor: pointer;
        }
        .btn_decline:hover {
            background: #b21f1f;
            border: 1px solid #b21f1f;
        }
        .myImg {
            width: 32%;
            border-radius: 5px;
            cursor: pointer;
            transition: 0.3s;
            margin-right: 1%;
        }

        .myImg:hover {opacity: 0.7;}

        /* The Modal (background) */
        .modal {
            display: none; /* Hidden by default */
            position: fixed; /* Stay in place */
            z-index: 1; /* Sit on top */
            padding-top: 70px; /* Location of the box */
            left: 0;
            top: 0;
            width: 100%; /* Full width */
            height: 100%; /* Full height */
            overflow: auto; /* Enable scroll if needed */
            background-color: rgb(0,0,0); /* Fallback color */
            background-color: rgba(0,0,0,0.9); /* Black w/ opacity */
        }

        /* Modal Content (image) */
        .modal-content {
            margin: auto;
            display: block;
            max-width: 93%;
            max-height: 80%;
        }

        /* Caption of Modal Image */
        #caption {
            margin: auto;
            display: block;
            width: 80%;
            max-width: 700px;
            text-align: center;
            color: #ccc;
            padding: 10px 0;
            height: 150px;
        }

        /* Add Animation */
        .modal-content, #caption {
            -webkit-animation-name: zoom;
            -webkit-animation-duration: 0.6s;
            animation-name: zoom;
            animation-duration: 0.6s;
        }

        @-webkit-keyframes zoom {
            from {-webkit-transform:scale(0)}
            to {-webkit-transform:scale(1)}
        }

        @keyframes zoom {
            from {transform:scale(0)}
            to {transform:scale(1)}
        }

        /* The Close Button */
        .close {
            position: absolute;
            top: 15px;
            right: 35px;
            color: #f1f1f1;
            font-size: 40px;
            font-weight: bold;
            transition: 0.3s;
        }

        .close:hover,
        .close:focus {
            color: #bbb;
            text-decoration: none;
            cursor: pointer;
        }

        /* 100% Image Width on Smaller Screens */
        @media only screen and (max-width: 700px){
            .modal-content {
                width: 100%;
            }
        }

        .unknown_info {
            color: #e32727;
        }
    </style>
</head>

<body>
    <noscript>
        <meta http-equiv="refresh" content="0; url=/noJS" />
        <style type="text/css">div {display: none;}</style>
    </noscript>
    <div class="body_wrapper">
        <jsp:include page="_menu.jsp" />
        <h3><spring:message code="label.here_are_posts_pending_approval" /> <span id="span_total_post"></span></h3>

        <div class="approve_post_wrapper" id="approve_post_wrapper"></div>

        <!-- The Modal -->
        <div id="myModal" class="modal">
            <span class="close">&times;</span>
            <img class="modal-content" style="min-height: 400px;" id="img01">
            <div id="caption"></div>
        </div>
    </div>
</body>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script>
    var LOCALE_STRING = '${sessionScope.localeString}';
    var approve_post_wrapper = document.getElementById("approve_post_wrapper");

    var STR_UNKNOWN = '<spring:message code="label.unknown" />';
    var STR_POSTER = '<spring:message code="label.poster" />';
    var STR_POST_TIME = '<spring:message code="label.post_time" />';
    var STR_POST_TITLE = "<spring:message code='label.post_title' />";
    var STR_POST_CONTENT = "<spring:message code='label.post_content' />";
    var STR_AREA = '<spring:message code="label.area" />';
    var STR_PRICE = '<spring:message code="label.price" />';
    var STR_ADDRESS_OF_RENTED_HOUSE = '<spring:message code="label.address_of_rented_house" />';
    var STR_CONTACT_TO_POSTER = '<spring:message code="label.contact_to_poster" />';
    var STR_CONTACT_PHONE = '<spring:message code="label.contact_phone" />';
    var STR_CONTACT_EMAIL = '<spring:message code="label.contact_email" />';
    var STR_CONTACT_ADDRESS = '<spring:message code="label.contact_address" />';
    var STR_ACCEPT = '<spring:message code="label.accept" />';
    var STR_DECLINE = '<spring:message code="label.decline" />';
    var STR_PHOTOS = '<spring:message code="label.hotel.photo" />';
    var STR_NO_IMAGES = '<spring:message code="label.no_images" />';
    var STR_MONTH = '<spring:message code="label.month" />';
    var STR_NO_POST_TO_APPROVE = "<spring:message code='label.there_is_no_pending_post' />";
    var STR_LOADING_MORE_POST = "<spring:message code='label.loading_more_post' />";
    var STR_TOTAL_PENDING_POST = "<spring:message code='label.total_pending_post' />";

    /*=============== get post using AJAX =====================*/
    getApprovePost();

    function getApprovePost() {
        var query =
            `query {
            postsToApprove {
                id
                user_id
                name
                description
                image_urls
                street
                district
                city
                area
                price
                time
                contact_name
                contact_phone
                contact_email
                contact_address
            }
            countPostsToApprove
        }`;
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                var total_post = JSON.parse(this.responseText).data.countPostsToApprove;
                document.getElementById("span_total_post").innerHTML = "(" + STR_TOTAL_PENDING_POST + ": " + total_post + ")";

                var postsToApprove = JSON.parse(this.responseText).data.postsToApprove;
                //console.log(postsToApprove);

                if(postsToApprove.length == 0) {
                    approve_post_wrapper.innerHTML = STR_NO_POST_TO_APPROVE;
                } else {
                    approve_post_wrapper.innerHTML = "";

                    for(var i=0; i<postsToApprove.length; i++) {
                        var divNode = document.createElement("div");
                        divNode.setAttribute("class", "approve_post_item");
                        divNode.setAttribute("id", "approve_post_item_" + postsToApprove[i].id);

                        var imgs = "";
                        if(postsToApprove[i].image_urls == null) {
                            imgs = "<div><span class='unknown_info'>" + STR_NO_IMAGES + "</span></div>"
                        } else if(!postsToApprove[i].image_urls.includes("|")) {
                            imgs = '<img class="myImg" src="' + postsToApprove[i].image_urls + '">';
                        } else {
                            var arr = postsToApprove[i].image_urls.split("|");
                            for(var j = 0; j < arr.length; j++) {
                                imgs = imgs + '<img class="myImg" src="' + arr[j] + '">';
                            }
                        }

                        var data = "<button class='btn_submit' onclick='acceptPost(this, " + postsToApprove[i].id + ")'>" + STR_ACCEPT + "</button>";
                        data += "<button style='margin-left: 2px;' class='btn_decline' onclick='declinePost(this, " + postsToApprove[i].id + ")'>" + STR_DECLINE + "</button>"
                        data = data +
                            "<table border='1'>\n" +
                            "    <tr>\n" +
                            "        <td class='td_label'>" + STR_POSTER + "</td>\n" +
                            "        <td class='td_content'>" + (postsToApprove[i].contact_name == null ? "<span class='unknown_info'>" + STR_UNKNOWN + '</span>' : postsToApprove[i].contact_name) + "</td>\n" +
                            "    </tr>\n" +
                            "    <tr>\n" +
                            "        <td class='td_label'>" + STR_POST_TIME + "</td>\n" +
                            "        <td class='td_content'>" + (LOCALE_STRING == 'en' ? formatDateUS(new Date(postsToApprove[i].time)) : formatDateVN(new Date(postsToApprove[i].time))) + "</td>\n" +
                            "    </tr>\n" +
                            "    <tr>\n" +
                            "        <td class='td_label'>" + STR_POST_TITLE + "</td>\n" +
                            "        <td class='td_content'>" + postsToApprove[i].name + "</td>\n" +
                            "    </tr>\n" +
                            "    <tr>\n" +
                            "        <td class='td_label'>" + STR_POST_CONTENT + "</td>\n" +
                            "        <td class='td_content'>" + postsToApprove[i].description + "</td>\n" +
                            "    </tr>\n" +
                            "    <tr>\n" +
                            "        <td class='td_label'>" + STR_AREA + "</td>\n" +
                            "        <td class='td_content'>" + postsToApprove[i].area + " m<sup>2</sup></td>\n" +
                            "    </tr>\n" +
                            "    <tr>\n" +
                            "        <td class='td_label'>" + STR_PRICE + "</td>\n" +
                            "        <td class='td_content'>" + addDotsToNumber(postsToApprove[i].price) + " đ/" + STR_MONTH + "</td>\n" +
                            "    </tr>\n" +
                            "    <tr>\n" +
                            "        <td class='td_label'>" + STR_ADDRESS_OF_RENTED_HOUSE + "</td>\n" +
                            "        <td class='td_content'>" + postsToApprove[i].street + ", " + postsToApprove[i].district + ", " + postsToApprove[i].city + "</td>\n" +
                            "    </tr>\n" +
                            "    <tr>\n" +
                            "        <td class='td_label'>" + STR_PHOTOS + "</td>\n" +
                            "        <td class='td_content'>" + imgs + "</td>\n" +
                            "    </tr>\n" +
                            "    <tr>\n" +
                            "        <td class='td_label'>" + STR_CONTACT_TO_POSTER + "</td>\n" +
                            "        <td class='td_content'>\n" +
                            "            <div>" + STR_CONTACT_PHONE + ": " + (postsToApprove[i].contact_phone == null ? "<span class='unknown_info'>" + STR_UNKNOWN + '</span>' : postsToApprove[i].contact_phone) + "</div>\n" +
                            "            <div>" + STR_CONTACT_EMAIL + ": " + (postsToApprove[i].contact_email == null ? "<span class='unknown_info'>" + STR_UNKNOWN + '</span>' : postsToApprove[i].contact_email) + "</div>\n" +
                            "            <div>" + STR_CONTACT_ADDRESS + ": " + (postsToApprove[i].contact_address == null ? "<span class='unknown_info'>" + STR_UNKNOWN + '</span>' : postsToApprove[i].contact_address) + "</div>\n" +
                            "        </td>\n" +
                            "    </tr>\n" +
                            "</table>"

                        divNode.innerHTML = data;
                        approve_post_wrapper.appendChild(divNode);
                    }

                    setEventForPhotos();
                }
            }
        };
        xhttp.open("GET", "/graphql?query=" + escape(query), true);
        xhttp.setRequestHeader("Content-Type", "application/json; charset=UTF-8");
        xhttp.send();
    }

    function setEventForPhotos() {
        /*=============== set event when click to a photo =====================*/
        var modal = document.getElementById('myModal');
        var modalImg = document.getElementById("img01");
        var captionText = document.getElementById("caption");

        // Get the image and insert it inside the modal - use its "alt" text as a caption
        var myImgs = document.getElementsByClassName("myImg");
        for(var i = 0; i < myImgs.length; i++) {
            myImgs[i].onclick = function() {
                modal.style.display = "block";
                modalImg.src = this.src;
                captionText.innerHTML = this.src;
            }
        }

        // Get the <span> element that closes the modal
        var span = document.getElementsByClassName("close")[0];

        // When the user clicks on <span> (x), close the modal
        span.onclick = function() {
            modal.style.display = "none";
        }
    }

    function acceptPost(element, post_id) {
        swal({
            title: "Are you sure to decline this post",
            icon: "warning",
            buttons: true,
            dangerMode: true,
        }).then((willDelete) => {
            if (willDelete) {
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function() {
                    if (this.readyState == 4 && this.status == 200) {
                        var kq = JSON.parse(this.responseText);
                        console.log(kq);

                        if(kq.status == 'success') {
                            deletePostFromScreen(element.parentNode, post_id, "Post accepted!");
                        } else {
                            swal({
                                title: "Error!",
                                text: kq.error,
                                icon: "error",
                                button: "OK",
                            });
                        }
                    }
                };
                xhttp.open("POST", "/admin/do-approve-post", true);
                xhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                xhttp.send("post_id=" + post_id);
            }
        });
    }

    function declinePost(element, post_id) {
        swal({
            title: "Are you sure to decline this post",
            icon: "warning",
            buttons: true,
            dangerMode: true,
        }).then((willDelete) => {
            if (willDelete) {
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function() {
                    if (this.readyState == 4 && this.status == 200) {
                        var kq = JSON.parse(this.responseText);
                        console.log(kq);

                        if(kq.status == 'success') {
                            deletePostFromScreen(element.parentNode, post_id, "Post declined!");
                        } else {
                            swal({
                                title: "Error!",
                                text: kq.error,
                                icon: "error",
                                button: "OK",
                            });
                        }
                    }
                };
                xhttp.open("POST", "/admin/do-decline-post", true);
                xhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                xhttp.send("post_id=" + post_id);
            }
        });
    }

    function sleep(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }

    /**
     * Xóa thẻ có id = approve_post_item_post_id
     * @param node chính là thẻ cần xóa
     * @param post_id
     * @param text
     * @returns {Promise<void>}
     */
    async function deletePostFromScreen(node, post_id, text) {
        //ban đầu cho thẻ node ẩn trong 500ms, sau đó mới xóa nó
        //chú ý: thẻ node chính là thẻ cần xóa, và có id = approve_post_item_post_id
        var parent = node.parentNode;
        $("#approve_post_item_" + post_id).hide(300, function () {
            parent.removeChild(node);
        });

        await sleep(400);   //chờ cho node bị remove hẳn
        // swal({
        //     title: "Success!",
        //     text: text,
        //     icon: "success",
        //     button: "OK",
        // });

        //Nếu ko còn bài đăng nào nữa thì tải thêm
        var approve_post_item = parent.getElementsByClassName("approve_post_item")[0];
        if(approve_post_item == null) {
            parent.innerHTML = STR_LOADING_MORE_POST;
            await sleep(50);
            getApprovePost();
        }
    }
</script>
</html>