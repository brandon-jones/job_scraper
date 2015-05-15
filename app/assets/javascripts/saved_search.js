$(document).ready(function() {
  return $('.saved-search-refresh').on("click", refreshSavedSearch);
});

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
