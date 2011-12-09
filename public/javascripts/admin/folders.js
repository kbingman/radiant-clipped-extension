Folder = {}

Folder.UpdateBroweser = Behavior.create({
  onclick: function(e){
    e.stop();
    var element = this.element;
    Folder.UpdateTable(element.href);
  }
});   

Folder.UpdateTable = function (url) {  
  var pageId = $('edit_page').action.split('/').last();
  $('select_all').removeClassName('pressed');
  Asset.AllWaiting();
  new Ajax.Updater('assets_table', url, {
    asynchronous: true, 
    evalScripts: false, 
    parameters: { page_id: pageId },
    method: 'get'
  });
}

Event.addBehavior({
  'a.remote': Folder.UpdateBroweser
});