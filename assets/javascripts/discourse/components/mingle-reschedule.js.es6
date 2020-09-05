import { default as computed } from 'ember-addons/ember-computed-decorators'
import { ajax } from 'discourse/lib/ajax'
import { longDate } from 'discourse/lib/formatter'
import showModal from 'discourse/lib/show-modal'

const messageBus = () => {
  return Discourse.__container__.lookup('message-bus:main')
}

export default Ember.Component.extend({
  @computed('filter', 'model')
  showButton() {
    return Discourse.SiteSettings.mingle_enabled &&
           this.filter == 'mingle' &&
           this.model
  },

  @computed("model.at")
  date(at) {
    return longDate(at)
  },

  init() {
    this._super()
    const updateModel = (data) => { this.set('model', data) }
    messageBus().subscribe('/mingle', updateModel)
    ajax('/admin/mingle/scheduled').then(updateModel)
  },

  actions: {
    reschedule() {
      showModal('mingle-reschedule-modal', {
        modalClass: 'mingle-modal',
        title: 'mingle.modal_title',
        model: this.model
      })
    }
  }
})
