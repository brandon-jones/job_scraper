$(document).ready(function() {
  $('#exampleModal').on('show.bs.modal', loadModalData);
  $('.ssr-updated').on('click', addUpdated)
  $('.ssr-denied').on('click', addDenied)
  $('.show-saved-search-form').on('click', showSavedSearchCreation)

  
  return $('#modal-save').on("click", saveLink);
});

showSavedSearchCreation = function(e) {
  var trRow = $("#saved-search-"+this.dataset.id+"-form");
  if (trRow[0].style.display == "none") {
    trRow.show(200, 'linear')
  } else {
    trRow.hide(200, 'linear');
  }
};

addUpdated = function(e) {
  ssr = this.dataset
  return $.ajax({
    type: 'POST',
    url: '/saved_search_results/updated',
    dataType: 'json',
    data: {
      saved_search_result: ssr
    },
    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
    success: function(data, textStatus) {
      console.log('testing');
      $('#'+editLink.replace('.','\\.'))[0].dataset.userLink = data.link;
      $('#link-to-site').val('');
      $('#exampleModal').modal('hide')
    }
  });
};

addDenied = function(e) {
  ssr = this.dataset
  return $.ajax({
    type: 'POST',
    url: '/saved_search_results/denied',
    dataType: 'json',
    data: {
      saved_search_result: ssr
    },
    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
    success: function(data, textStatus) {
      console.log('testing');
      $('#'+editLink.replace('.','\\.'))[0].dataset.userLink = data.link;
      $('#link-to-site').val('');
      $('#exampleModal').modal('hide')
    }
  });
};

loadModalData = function(e) {
  var button = $(e.relatedTarget); // Button that triggered the modal
  var id = button.data('id'); // Extract info from data-* attributes
  var company = button.data('title'); // Extract info from data-* attributes
  var user_link = button[0].dataset.userLink;
  // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
  // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
  var modal = $(this);
  modal.find('.modal-title').text('Add/Edit link for ' + company);
  modal.find('#modal-save')[0].dataset.id = id;
  modal.find('#link-to-site').val(user_link);
};

saveLink = function(e) {
  e.stopPropagation();
  e.preventDefault();
  link = $('#link-to-site').val();
  editLink = "edit-link-"+this.dataset.id;

  if ( is_valid_url(link) == false && link.length > 0 ) {
    $('#modal-errors')[0].textContent = 'Please fill in a valid url';
  } else {
    $('#modal-errors')[0].textContent = '';
    id = this.dataset.id;
    link = $('#link-to-site').val();
    return $.ajax({
      type: 'POST',
      url: '/saved_search_results/update_link',
      dataType: 'json',
      data: {
        id: id,
        link: link
      },
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      success: function(data, textStatus) {
        var a = document.createElement('a');
        var linkText = document.createTextNode(data.company);

        var row = $('tr#'+data.id.replace('.','\\.')+'-row');
        var td = row.find('td').first()

        if (data.link.length > 0) {
          td.text('');
          a.appendChild(linkText);
          a.title = data.link;
          a.href = data.link;
          a.target = '_blank';
          td.append(a);
        } else {
          td.text(linkText.textContent);
        }

        $('#'+editLink.replace('.','\\.'))[0].dataset.userLink = data.link;
        $('#link-to-site').val('');
        $('#exampleModal').modal('hide')
      }
    });
  }
};

 function is_valid_url(s) {    
  var regexp = /^(https?|ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i;
  return regexp.test(s);    
 };