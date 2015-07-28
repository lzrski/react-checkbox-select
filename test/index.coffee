React         = require "react/addons"

chai          = require "chai"
jsdom         = require "jsdom"
sinon         = require "sinon"
chai.use        require "sinon-chai"

{ TestUtils } = React.addons
{ expect }    = chai

# Component to be tested
CheckboxSelect = require ".."

document = null

describe "CheckboxSelect component", ->

  beforeEach ->
    document = jsdom.jsdom "<!doctype html><html><body></body></html>"
    global.document   = document
    global.window     = document.defaultView
    global.navigator  = userAgent: "node.js"

  it "is a react component"

  it "has a name CheckboxSelect"

  it "can be instantiated empty"

  it "can be instantiated with checkboxes as children"

  it "can be instantiated with other children as well"

  it "can be instantiated with checkboxes nested in other children"

  it "has a value property reflecting checkboxes state"

  describe "onSelect method", ->

    it "can be provided via props"

    it "is called once for each checkbox change"

    it "does not supress childrens onChange event"

    it "is gets event object passed as an argument"

    describe "event argument", ->

      it "has a target - CheckboxSelect component"

      it "has an originalTarget - changed checkbox element"

  #
  #   # Works without JSDOM
  #   el = <div>Hello</div>
  #
  #   expect el
  #     .to.exist
  #     .and.to.have.property "props"
  #     .with.property        "children"
  #     .that.eql             "Hello"
  #
  # it "can handle click event", ->
  #   # Requires JSDOM setup
  #   # TODO: use Sinon to spy on functions
  #   callback = sinon.spy()
  #
  #   component = TestUtils.renderIntoDocument <ClickableButton onClick = { callback} />
  #
  #   TestUtils.Simulate.click React.findDOMNode component
  #   expect callback
  #     .to.have.been.called
