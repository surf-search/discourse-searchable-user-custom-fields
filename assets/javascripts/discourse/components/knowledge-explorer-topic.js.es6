import { reads } from "@ember/object/computed";
import { computed } from "@ember/object";

export default Ember.Component.extend({
  classNames: "chord-directory-topic",

  originalPostContent: reads("post.cooked"),

  post: computed("topic", function() {
    return this.store.createRecord(
      "post",
      this.topic.post_stream.posts.firstObject
    );
  }),

  model: computed("post", "topic", function() {
    const post = this.post;

    if (!post.topic) {
      post.set("topic", this.topic);
    }

    return post;
  }),

  didInsertElement() {
    this._super(...arguments);

    document
      .querySelector("body")
      .classList.add("archetype-chord-directory-topic");
  },

  willDestroyElement() {
    this._super(...arguments);

    document
      .querySelector("body")
      .classList.remove("archetype-chord-directory-topic");
  }
});
