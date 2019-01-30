# Lasso Scaffold Generator

Scaffold generator for creating Lasso Objects.

## Usage

There is a command line interface (CLI), which allows you to run the scaffold generator, 
and view the help documentation.

### Overview

The follow the steps below to create a new Lasso Module.

1. Create an attributes YAML file. This is where you define all the attributes of your model. See the [1. Supplying Attribute data](#1-supplying-attribute-data) section below.
2. Run the generate scaffold command. See the [2. Run the Generate Command](#2-run-the-generate-command) section below.
3. Move the generated files to your Lasso website. See the [3. Install Files](#3-install-files) section below.
4. See the [4. Configure Object Loading](#4-configure-object-loading) section below.

### 1. Supplying Attribute data

Copy the `data/_example_attributes.yml` and rename it replacing `_example` with the name of your Lasso Module. For 
example, if your module was called `coupon`, name the file `coupon_attributes.yml`. 

#### Attribute Data File Format

The attribute data is a YAML file, and is formatted like the following example:

```yaml

---
-
  name: address
  field: Address1
  type: String
  default: 
  usage: required
-
  name: unit
  field: Address2
  type: String
  default: 
  usage: optional
```

This produces the following in the Ruby code:

```ruby
@attributes = [
  {
    name: 'address',
    field: 'Address1',
    type: 'String',
    default: 
    usage: 'required' 
  },
  {
    name: 'unit',
    field: 'Address2',
    type: 'String',
    default: 
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

### 2. Run the Generate Command

1. First `cd` to the root of this app.
2. Launch the app's Bash console. Enter the $`./bash` command. This will open a bash prompt running in a Docker container.
3. Enter a command like `ruby ./generator.rb scaffold NAME` where `NAME` is the non-plural version of the module name, 
  use all lowercase characters and underscore case (i.e. snakecase) format.

This will generate all your files and place them inside the `output` folder. The code will be in a folder with the 
plural version of the name you supplied to the generator command.

### 3. Install Files

After you've generated your new Lasso Module, you will find it in the `output` folder in the root of this project. To 
install it in a Lasso website you'll need to drag-and-drop the module folder form the `output` folder into the root of 
the Lasso website. Add 

### 4. Configure Object Loading

Add file path for the two new Lasso custom type files to the `/library/load_custom_tags_and_types.inc` file. Similar to the Coupon 
example below:  
```object-c
    // Coupon
    '/coupons/Types/coupon_type.inc',
    '/coupons/Types/coupons_type.inc',
```

This will make your new Lasso custom types available on every page of the web site.

