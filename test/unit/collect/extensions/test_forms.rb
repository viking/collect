require 'helper'

class TestForms < CollectExtensionTest
  def setup
    super
    @project = project = stub('project', :id => 1, :name => 'foo')
    @role = role = stub('role', :project => project, :is_admin => true)
    app.before do
      @project = project
      @role = role
    end
    app.filters[:before].unshift(app.filters[:before].pop)
  end

  test "new form" do
    section = stub('section', :name => 'main', :position => 0, :questions => [])
    form = stub('form', :name => nil, :errors => [], :sections => [section])
    Collect::Form.expects(:new).with(:project => @project).returns(form)
    form.expects(:sections_attributes=).with([{:name => 'main', :position => 0}])

    get '/admin/projects/1/forms/new'
    assert_equal 200, last_response.status
  end

  test "creating a form" do
    attributes = {
      'name' => 'foo',
      'sections_attributes' => {
        '0' => {
          'name' => 'main',
          'position' => '0',
          'questions_attributes' => {
            '0' => {
              'name' => 'person_id',
              'prompt' => 'Person ID',
              'type' => 'Integer',
              'position' => '0'
            }
          }
        }
      }
    }
    form = stub('new form')
    Collect::Form.expects(:new).with(attributes.merge(:project => @project)).returns(form)
    form.expects(:save).returns(true)

    post '/admin/projects/1/forms', 'form' => attributes
    assert_equal 302, last_response.status
    assert_equal 'http://example.org/admin/projects/1', last_response['location']
  end

  test "creating an invalid form" do
    attributes = {
      'name' => 'foo',
      'sections_attributes' => {
        '0' => {
          'name' => 'main',
          'position' => '0',
          'questions_attributes' => {
            '0' => {
              'name' => 'person_id',
              'prompt' => 'Person ID',
              'type' => 'Integer',
              'position' => '0'
            }
          }
        }
      }
    }
    question = stub('question', :name => 'person_id', :prompt => 'Person ID', :type => 'Integer', :position => 0)
    section = stub('section', :name => 'main', :position => 0, :questions => [question])
    form = stub('new form', :name => 'foo', :sections => [section])
    Collect::Form.expects(:new).with(attributes.merge(:project => @project)).returns(form)
    form.expects(:save).returns(false)
    form.expects(:errors).at_least_once.returns(stub(:empty? => false, :full_messages => ['foo']))

    post '/admin/projects/1/forms', 'form' => attributes
    assert_equal 200, last_response.status
  end

  test "edit form" do
    question = stub('question', :name => 'person_id', :prompt => 'Person ID', :type => 'Integer', :position => 0)
    section = stub('section', :name => 'main', :position => 0, :questions => [question])
    form = stub('form', :id => 1, :project_id => 1, :name => 'foo', :sections => [section], :errors => [])
    @project.stubs(:forms_dataset).returns(mock { expects(:[]).with(:id => '1').returns(form) })

    get '/admin/projects/1/forms/1/edit'
    assert_equal 200, last_response.status
  end

  test "update form" do
    attributes = {
      'name' => 'foo',
      'sections_attributes' => {
        '0' => {
          'name' => 'main',
          'position' => '0',
          'questions_attributes' => {
            '0' => {
              'name' => 'person_id',
              'prompt' => 'Person ID',
              'type' => 'Integer',
              'position' => '0'
            }
          }
        }
      }
    }
    form = stub('form')
    @project.stubs(:forms_dataset).returns(mock { expects(:[]).with(:id => '1').returns(form) })
    form.expects(:set).with(attributes)
    form.expects(:save).returns(true)

    post '/admin/projects/1/forms/1', 'form' => attributes
    assert_equal 302, last_response.status
    assert_equal 'http://example.org/admin/projects/1', last_response['location']
  end

  test "update form with invalid attributes" do
    attributes = {
      'name' => 'foo',
      'sections_attributes' => {
        '0' => {
          'name' => 'main',
          'position' => '0',
          'questions_attributes' => {
            '0' => {
              'name' => 'person_id',
              'prompt' => 'Person ID',
              'type' => 'Integer',
              'position' => '0'
            }
          }
        }
      }
    }
    question = stub('question', :name => 'person_id', :prompt => 'Person ID', :type => 'Integer', :position => 0)
    section = stub('section', :name => 'main', :position => 0, :questions => [question])
    form = stub('form', :id => 1, :project_id => 1, :name => 'foo', :sections => [section])
    form.expects(:errors).at_least_once.returns(stub(:empty? => false, :full_messages => ['foo']))
    @project.stubs(:forms_dataset).returns(mock { expects(:[]).with(:id => '1').returns(form) })
    form.expects(:set).with(attributes)
    form.expects(:save).returns(false)

    post '/admin/projects/1/forms/1', 'form' => attributes
    assert_equal 200, last_response.status
  end

  test "show form" do
    question = stub('question', :name => 'person_id', :prompt => 'Person ID', :type => 'Integer', :position => 0)
    section = stub('section', :name => 'main', :position => 0, :questions => [question])
    form = stub('form', :name => 'foo', :sections => [section])
    @project.stubs(:forms_dataset).returns(mock { expects(:[]).with(:id => '1').returns(form) })

    get '/admin/projects/1/forms/1'
    assert_equal 200, last_response.status
  end
end
