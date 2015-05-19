$(document).ready(function() {
  $('.ssr-exapnd-link').on("click", expandSavedSearchResults);
  return $('.saved-search-refresh').on("click", refreshSavedSearch);
});

expandSavedSearchResults = function(e) {
  var link = this;
  var table = $('#'+this.dataset.score.replace('.','\\.')+"-table");

  if (table[0].style.display == "none") {
    table.show(200, 'linear');
    link.classList.remove("glyphicon-plus-sign")
    link.classList.add("glyphicon-minus-sign")
  } else {
    table.hide(200, 'linear');
    link.classList.remove("glyphicon-minus-sign")
    link.classList.add("glyphicon-plus-sign")
  }
};

refreshSavedSearch = function(e) {
  e.stopPropagation();
  e.preventDefault();
  refreshLink = this;
  refreshLink.classList.add('glyphicon-refresh-animate')

  parent_unique_id = refreshLink.dataset.parentUniqueId;
  score = refreshLink.dataset.score;

  $.ajax({
    type: 'POST',
    url: '/saved_searches/refresh',
    dataType: 'json',
    data: {
      parent_unique_id: parent_unique_id,
      score: score
    },
    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
    success: function(data, textStatus) {
      console.log('testing');
    }
  });

  return refreshLink.classList.remove('glyphicon-refresh-animate');
};


