import Category from "discourse/models/category";
import ChordDirectory from "discourse/plugins/discourse-chord-directory/discourse/models/chord-directory";

export default Ember.Route.extend({
  queryParams: {
    searchTerm: {
      replace: true
    }
  },

  model(params) {
    return ChordDirectory.list(params);
  },

  setupController(controller, model) {
    const categories = Category.list();

    let topics = model.topics.topic_list.topics;

    topics = topics.map(t => {
      t.category = categories.findBy("id", t.category_id);
      return t;
    });

    model.topics.topic_list.topics = topics;

    controller.set("topic", model.topic);
    controller.set("model", model);
  }
});
