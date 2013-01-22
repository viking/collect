require 'helper'

class TestSection < CollectUnitTest
  def new_section(attribs = {})
    Collect::Section.new({
      :name => 'foo',
      :form => @form
    }.merge(attribs))
  end

  def setup
    super
    @project = Collect::Project.create!(:name => 'foo', :database_adapter => 'sqlite')
    @form = Collect::Form.create!(:name => 'foo', :project => @project)
  end

  test "sequel model" do
    assert_equal Sequel::Model, Collect::Section.superclass
  end

  test "requires name" do
    section = new_section(:name => nil)
    assert !section.valid?
  end

  test "requires form_id" do
    section = new_section(:form => nil)
    assert !section.valid?
  end

  test "many_to_one form" do
    section = new_section
    assert_respond_to section, :form
  end

  test "one_to_many question" do
    section = new_section
    assert_respond_to section, :questions
  end

  test "accepts nested attributes array for questions" do
    section = new_section(:questions_attributes => [
      {:name => 'foo', :prompt => 'foo?', :type => 'String'}
    ])
    assert section.save
    assert_equal 1, section.questions.length
  end

  test "accepts nested attributes hash for questions" do
    section = new_section(:questions_attributes => {
      '0' => {'name' => 'foo', 'prompt' => 'foo?', 'type' => 'String'}
    })
    assert section.save
    assert_equal 1, section.questions.length
  end

  test "child validation failure causes rollback" do
    section = new_section(:questions_attributes => [{}])
    assert !section.save
  end

  test "can't be created if parent form belongs to project in production" do
    @project.update(:status => 'production')
    section = new_section
    assert !section.save
  end

  test "can't be updated if parent form belongs to project in production" do
    section = new_section.save
    @project.update(:status => 'production')
    assert !section.update(:name => 'bar')
  end
end
