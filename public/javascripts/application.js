function getUploadProgress(UUID) { //prep info for the upload progress tracking
	var options = {
		uuid: UUID, //uuid from the hidden field
		uploadURL: '/progress', //url that we're using for tracking, specified in the vhost file
		progressBar: '#progressBar' + UUID //id of the div we're adding the progress bar to
	} 
	$(options.progressBar).progressBar(0); //add the progressbar, make sure it's at 0%
	$('#uploading'+UUID).fadeIn(); //show the div holding the progressbar
	uploadProgress(options); //the actual ajax call to get the progress
};

function uploadProgress(options) {
	$.ajax({
		type: "GET",
		url: options.uploadURL,
		dataType: "json",
		beforeSend: function(xhr) {
			xhr.setRequestHeader("X-Progress-ID", options.uuid ); //add the X-Progress-ID to the header so the apache progress module knows what asset we're querying about
		},
		success: function(upload) {
			if (upload.state == 'uploading') {
				upload.percents = Math.floor((upload.received / upload.size)*1000)/10; //if uploading, calculate the percent complete
				$(options.progressBar).progressBar(upload.percents); //update the progress bar
			}
			if (upload.state == 'uploading' || upload.state == 'starting' ) {
				uploadProgress(options); //if the upload is still in progress, or hasn't started yet, make another ajax call
			}
			if (upload.state == 'done') {
				$(options.progressBar).progressBar(100); //when the upload is done, update the progress bar to 100%
			};
		}
	});
};

function addChange(inputId, uuid) { //apply the onchange event to the file_field with the id of 'inputId'
	$(inputId).bind('change', function(){
		getUploadProgress(uuid); //call the function to track the uploads
		this.form.submit();  //submit the form
		this.disabled='true'; //disables the 'Browse' button on the file_field
	 });
};

function updateProgressId(oldUUID) {
	var oldFormId = '#' + oldUUID;
	var oldErrorId = '#error' + oldUUID;
	var oldFormDiv = '#form' + oldUUID;
	var oldFileField = '#file' + oldUUID;
	var oldUploadingDiv = '#uploading' + oldUUID;
	var oldProgressBar = '#progressBar' + oldUUID;
	
	$(oldFileField).unbind("change");
	var newUUID = "";
	for (i = 0; i < 10; i++) {
		newUUID += Math.floor(Math.random() * 16).toString(16);
	};
	$(oldFormId).attr("action", "/assets.js?X-Progress-ID=" + newUUID + "&form=" + newUUID );
	$(oldFileField).bind("change", function() { $('#error' + newUUID).fadeOut();});
	$(oldFormId).attr("id", newUUID);
	$(oldFileField).attr("id", "file" + newUUID);
	$(oldFormDiv).attr("id", "form" + newUUID);
	$(oldErrorId).attr("id", "error" + newUUID);
	$(oldUploadingDiv).attr("id", "uploading" + newUUID);
	$(oldProgressBar).progressBar(0, {speed: -10});
	$(oldProgressBar).attr("id", "progressBar" + newUUID);
	
	addChange('#file' + newUUID, newUUID);
};