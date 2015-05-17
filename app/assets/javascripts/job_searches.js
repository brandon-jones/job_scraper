$(document).ready(function() {

  fixLocalTime();

  return $('.apply-for-job').on("click", applyForJob);
});

fixLocalTime = function(e) {
  timeObjs = $('.time-tooltip');
  $.each(timeObjs, function( index, value ) {
    time = value.title.replace('Last updated: ','');
    dateTime = time.replace(/.+?"/,'').replace(/".+/,'');
    conversion = time.replace(/.+data-local="/,'').replace(/">.+/,'');
    switch(conversion) {
      case "time-ago":
        rightTime = LocalTime.relativeTimeAgo(new Date(dateTime));
      break;
      default:
        rightTime = LocalTime.strftime(new Date(dateTime), "%B %e, %Y %l:%M%P");
      break;
    }
    value.title = value.title.replace(/<.+/,rightTime)
  });
  

};

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
    url: '/saved_search_results/create',
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
