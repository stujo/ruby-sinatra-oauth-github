$(function($){
  console.log('Loaded notes.js');
  $('.hidden_form_trigger').click(function(e){
    var formId = this.dataset['hiddenFormId'];
    if(formId){
      e.preventDefault();
      document.getElementById(formId).submit();
    }
  });
});