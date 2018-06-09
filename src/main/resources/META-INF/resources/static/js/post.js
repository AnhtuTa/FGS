var select_file_wrapper = document.getElementById("select_file_wrapper");
var images_wrapper = document.getElementById("images_wrapper");

function fire_ajax_submit() {
    // Get form
    var form = $('#fileUploadForm')[0];
    var data = new FormData(form);

    $("#btnSubmit").prop("disabled", true);

    $.ajax({
        type: "POST",
        enctype: 'multipart/form-data',
        url: "/rest/upload/",
        data: data,
        //http://api.jquery.com/jQuery.ajax/
        //https://developer.mozilla.org/en-US/docs/Web/API/FormData/Using_FormData_Objects
        processData: false, //prevent jQuery from automatically transforming the data into a query string
        contentType: false,
        cache: false,
        timeout: 600000,
        success: function (data) {

        	data = JSON.parse(data);
            $("#result").text(data);
            console.log("SUCCESS : ", data);
            $("#btnSubmit").prop("disabled", false);
            
            var divNode = document.createElement("div");
            divNode.classList.add("preview_image_wrapper");
            divNode.style.backgroundImage = "url('" + data.image_url + "')";

            var btnNode = document.createElement("div");
            btnNode.classList.add("btn-close");
            btnNode.setAttribute("title", STR_REMOVE_THIS_IMAGE);
            btnNode.setAttribute("onclick", "removeParent(this)");
            
            var iNode = document.createElement("i");
            iNode.classList.add("fa");
            iNode.classList.add("fa-times");
            
            var inputNode = document.createElement("input");
            inputNode.style.display = 'none';
            inputNode.setAttribute("name", "image_url");
            inputNode.setAttribute("value", data.image_url);
            
            btnNode.appendChild(iNode);
            divNode.appendChild(btnNode);
            divNode.appendChild(inputNode);
            images_wrapper.appendChild(divNode);
            
            select_file_wrapper.innerHTML = "";
            var data = '<input type="file" style="opacity: 0;height: 0;width: 0;" name="file_upload" id="input_file" accept="image/*" onchange="fire_ajax_submit()"/><br/><br/>';
            select_file_wrapper.innerHTML = data;
        },
        error: function (e) {
            //$("#result").text(e.responseText);
            console.log("ERROR : ", e);
            if(e.responseJSON.exception != null) {
            	if(e.responseJSON.exception == "org.springframework.web.multipart.MultipartException" && e.responseJSON.message.includes("FileSizeLimitExceededException")) {
                	alert(STR_ERR_FILE_SIZE_LIMIT);
                }
            }
            $("#btnSubmit").prop("disabled", false);

        }
    });
}

function removeParent(element) {
	var parent = element.parentElement;
	parent.parentNode.removeChild(parent);
}

function chooseFile() {
	$("input[type='file']").trigger('click');
}