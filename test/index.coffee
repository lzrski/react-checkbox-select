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

  it "is a react component", ->
    expect CheckboxSelect
      .to.have.property 'prototype',  React.Component

  it "has a name of CheckboxSelect", ->
    expect CheckboxSelect
      .to.have.property 'name',       'CheckboxSelect'

  it "can be instantiated empty", ->
    TestUtils.renderIntoDocument <CheckboxSelect />
    # There should be no error

  it "can be instantiated with checkboxes as children", ->
    TestUtils.renderIntoDocument <CheckboxSelect>
      <input type = 'checkbox' value = 'x'/>
      <input type = 'checkbox' value = 'y'/>
      <input type = 'checkbox' value = 'z'/>
    </CheckboxSelect>
    # There should be no error

  it "can be instantiated with other children as well", ->
    TestUtils.renderIntoDocument <CheckboxSelect>
      <input type = 'checkbox' value = 'x' id = 'x'/>
      <label htmlFor = 'x'>Ex</label>

      <input type = 'checkbox' value = 'y' id = 'y'/>
      <label htmlFor = 'y'>Why</label>

      <input type = 'checkbox' value = 'z' id = 'z'/>
      <label htmlFor = 'z'>Zee</label>
    </CheckboxSelect>
    # There should be no error

  it "can be instantiated with checkboxes nested in other children", ->
    TestUtils.renderIntoDocument <CheckboxSelect>
      <div>
        <input type = 'checkbox' value = 'x' id = 'x'/>
        <label htmlFor = 'x'>Ex</label>
      </div>

      <div>
        <input type = 'checkbox' value = 'y' id = 'y'/>
        <label htmlFor = 'y'>Why</label>
      </div>

      <div>
        <input type = 'checkbox' value = 'z' id = 'z'/>
        <label htmlFor = 'z'>Zee</label>
      </div>
    </CheckboxSelect>
    # There should be no error

  it "has a value property reflecting checkboxes state", ->
    component = TestUtils.renderIntoDocument <CheckboxSelect>
      <div>
        <input
          type    = 'checkbox'
          value   = 'x'
          id      = 'x'
          checked = { yes }
        />
        <label htmlFor = 'x'>Ex</label>
      </div>

      <div>
        <input
          type    = 'checkbox'
          value   = 'y'
          id      = 'y'
          checked = { no }
        />
        <label htmlFor = 'y'>Why</label>
      </div>

      <div>
        <input
          type    = 'checkbox'
          value   = 'z'
          id      = 'z'
          checked = { yes }
        />
        <label htmlFor = 'z'>Zee</label>
      </div>
    </CheckboxSelect>

    expect component
      .to.have.property       'value'
      .which.is.an.instanceOf Array
      .and.eql                ['x', 'z']

  describe "onSelect method", ->

    it "can be provided via props", ->
      callback  = -> # Empty function
      component = TestUtils.renderIntoDocument <CheckboxSelect onChange = { callback }>
        <input type = 'checkbox' value = 'x'/>
        <input type = 'checkbox' value = 'y'/>
        <input type = 'checkbox' value = 'z'/>
      </CheckboxSelect>
      expect component
        .to.have.property 'props'
        .which.is.an      'object'
        .with.property    'onChange',   callback

    it "is called once for each checkbox change", ->
      callback = sinon.spy()

      component = TestUtils.renderIntoDocument <CheckboxSelect
        onChange = { callbacks.component }
      >
        <input type = 'checkbox' value = 'x' ref = 'x'/>
        <input type = 'checkbox' value = 'y' ref = 'y'/>
        <input type = 'checkbox' value = 'z' ref = 'z'/>
      </CheckboxSelect>

      TestUtils.Simulate.click React.findDOMNode component.refs.y

      expect callback
        .to.have.been.calledOnce

    it "does not supress childrens onChange event", ->
      callbacks  =
        component : sinon.spy()
        input     : sinon.spy()

      component = TestUtils.renderIntoDocument <CheckboxSelect
        onChange = { callbacks.component }
      >
        <input type = 'checkbox' value = 'x' ref = 'x'/>
        <input type = 'checkbox' value = 'y' ref = 'y'/>
        <input
          type      = 'checkbox'
          value     = 'z'
          ref       = 'z'
          onChange  = { callbacks.input }
        />
      </CheckboxSelect>

      TestUtils.Simulate.click React.findDOMNode component.refs.y

      expect callbacks.component
        .to.have.been.calledOnce

      expect callbacks.input
        .to.have.been.calledOnce
        .and
        .to.have.been.calledBefore callbacks.component

    it "gets event object passed as an argument", ->
      callback = sinon.spy()

      component = TestUtils.renderIntoDocument <CheckboxSelect
        onChange = { callback }
      >
        <input type = 'checkbox' value = 'x' ref = 'x'/>
        <input type = 'checkbox' value = 'y' ref = 'y'/>
        <input type = 'checkbox' value = 'z' ref = 'z'/>
      </CheckboxSelect>

      TestUtils.Simulate.click React.findDOMNode component.refs.y

      expect callback
        .to.have.been.calledWithMatch (args) ->
          args[0] instanceOf Event

    describe "event argument", ->

      it "has a target - CheckboxSelect component", ->
        callback = sinon.spy()

        component = TestUtils.renderIntoDocument <CheckboxSelect
          onChange = { callback }
        >
          <input type = 'checkbox' value = 'x' ref = 'x'/>
          <input type = 'checkbox' value = 'y' ref = 'y'/>
          <input type = 'checkbox' value = 'z' ref = 'z'/>
        </CheckboxSelect>

        input = React.findDOMNode component.refs.x
        TestUtils.Simulate.click input

        expect callback
          .to.have.been.calledWithMatch (args) ->
            args[0].target is component


      it "has an originalTarget - changed checkbox element", ->
        callback = sinon.spy()

        component = TestUtils.renderIntoDocument <CheckboxSelect
          onChange = { callback }
        >
          <input type = 'checkbox' value = 'x' ref = 'x'/>
          <input type = 'checkbox' value = 'y' ref = 'y'/>
          <input type = 'checkbox' value = 'z' ref = 'z'/>
        </CheckboxSelect>

        input = React.findDOMNode component.refs.x
        TestUtils.Simulate.click input

        expect callback
          .to.have.been.calledWithMatch (args) ->
            args[0].originalTarget is input
