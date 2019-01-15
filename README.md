# Lasso Scaffold Generator

Scaffold generator for creating Lasso Objects.

## Usage

There is a command line interface (CLI), which allows you to run the scaffold generator, 
and view the help documentation.


## Supplying Attribute data

Copy the `data/_example_attributes.yml` and rename it replacing `_example` with the name of your Lasso Module. For 
example, if your module was called `coupon`, name the file `coupon_attributes.yml`. 

### Attribute Data File Format

The attribute data is a YAML file, and is formatted like the following example:

```yaml

---
-
  name: address
  field: Address1
  type: String
  usage: required
-
  name: unit
  field: Address2
  type: String
  usage: optional
```

This produces the following in the Ruby code:

```ruby
@attributes = [
  {
    name: 'address',
    field: 'Address1',
    type: 'String',
    usage: 'required' 
  },
  {
    name: 'unit',
    field: 'Address2',
    type: 'String',
    usage: 'optional' 
  }
]
```

#### Data Fields

- `name` is the name of your attribute. Example: `store_number`.
- `field` is the Lasso database field it maps to. Example: 'StoreNbr'.
- `type` is the Lasso data type to treat the attribute as. Examples: `string`, `integer`, or `boolean`.
- `usage` identifies how we use the attribute. It takes one of the following values: `required`, `optional`, `hidden`, `internal`, or `virtual`
  - `required`: accept input, in db
  - `optional`: accept input, in db
  - `hidden`:   no input,     in db
  - `internal`: no input,     no db
  - `virtual`:  accept input, no db

##### Usage Values

| Name       | Allows Input | Persists to Database |
|------------|--------------|----------------------|
| `required` | yes          | yes                  |
| `optional` | yes          | yes                  |
| `hidden`   | no           | yes                  |
| `internal` | no           | no                   |
| `virtual`  | yes          | no                   |

