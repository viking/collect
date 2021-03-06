require 'helper'

class TestForm < CollectUnitTest
  def setup
    super
    @project = Collect::Project.create!(:name => 'foo', :database_adapter => 'sqlite')
  end

  def new_form(attribs = {})
    Collect::Form.new({
      :name => 'foo',
      :project => @project
    }.merge(attribs))
  end

  test "sequel model" do
    assert_equal Sequel::Model, Collect::Form.superclass
  end

  test "requires name" do
    form_1 = new_form(:name => nil)
    assert !form_1.valid?

    form_2 = new_form(:name => "")
    assert !form_2.valid?
  end

  test "requires unique name" do
    form_1 = new_form(:name => 'foo')
    assert form_1.save
    form_2 = new_form(:name => 'foo')
    assert !form_2.valid?
  end

  test "sets empty slug" do
    form_1 = new_form(:name => 'foo bar')
    assert form_1.save
    assert_equal 'foo_bar', form_1.slug

    form_2 = new_form(:name => 'foo bar 2', :slug => "")
    assert form_2.save
    assert_equal 'foo_bar_2', form_2.slug
  end

  test "does not set non-empty slug" do
    form = new_form(:name => 'foo bar', :slug => 'baz')
    assert form.save
    assert_equal 'baz', form.slug
  end

  test "requires unique slug" do
    form_1 = new_form(:name => 'foo')
    assert form_1.save
    form_2 = new_form(:name => 'foo bar', :slug => 'foo')
    assert !form_2.valid?
  end

  test "many_to_one project" do
    form = new_form
    assert_respond_to form, :project
  end

  test "requires project_id" do
    form = new_form(:project => nil)
    assert !form.valid?
  end

  test "one_to_many sections" do
    form = new_form
    assert_respond_to form, :sections
  end

  test "accepts nested attributes array for sections" do
    form = new_form({:sections_attributes => [
      {:name => 'foo', :position => 0}
    ]})
    assert form.save
    assert_equal 1, form.sections.length
  end

  test "accepts nested attributes hash for sections" do
    form = new_form('sections_attributes' => {
      '0' => {'name' => 'foo', 'position' => '0'}
    })
    assert form.save
    assert_equal 1, form.sections.length
  end

  test "child validation failure causes rollback" do
    form = new_form(:sections_attributes => [{}])
    assert !form.save
  end

  test "forms that belong to published projects can't be created" do
    @project.update(:status => 'production')

    form = new_form(:name => 'foo')
    assert !form.save
  end

  test "forms that belong to published projects can't be updated" do
    form = new_form(:name => 'foo')
    assert form.save
    @project.update(:status => 'production')
    assert !form.update(:name => 'bar')
  end
end
