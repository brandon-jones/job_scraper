$(document).ready(function() {
  return $('.apply-for-job').on("click", applyForJob);
});

applyForJob = function(e) {
  e.stopPropagation();
  e.preventDefault();
  var data_set = this.dataset;
  button = this;
  var saved_search = {};
  $.each(data_set, function( index, value ) {
    var key = index.replace('result','').split(/(?=[A-Z])/).join('_').toLowerCase();
    saved_search[key] = value;
  });
  return $.ajax({
    type: 'POST',
    url: '/apply_for_job',
    dataType: 'json',
    data: {
      saved_search: saved_search,
    },
    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
    success: function(data, textStatus) {
      button.style.visibility = "hidden";
      button.parentElement.parentElement.classList.add('applied');
    }
  });
};
