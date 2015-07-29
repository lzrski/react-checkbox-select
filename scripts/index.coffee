# Use react with addons enabled (for CloneWithProps method)
React = require 'react/addons'

module.exports = class CheckboxSelect extends React.Component
  # It's completely stateless :)
  constructor: (props, context) ->
    super props, context

    @value  = []  # Calculated in handleChildChange

  @defaultProps  :
    onChange  : (event) -> console.log event.target.value.join ', '

  handleChildChange: (event) =>
    @value  = []
    for ref, component of @refs
      { type, checked, value} = do component.getDOMNode
      if type is 'checkbox' and checked then @value.push value

    event.originalTarget = event.target
    event.target = @

    @props.onChange event

  render: ->
    <div>
      {
        # Clear inputs on each render
        @inputs = []

        React.Children.map @props.children, (child, i) =>
          if child.type is 'input'
            # Clone and set onChange event
            # Also add refs to allow access fron onChildChange
            clone = React.addons.cloneWithProps child,
              onChange: @handleChildChange
              ref     : "input-#{i}"

            @inputs.push clone

            return clone

          # If it's not an input (e.g. a label), then just pass it through
          else return child
      }
    </div>
