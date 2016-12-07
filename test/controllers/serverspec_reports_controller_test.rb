require 'test_helper'

class ServerspecReportsControllerTest < ActionController::TestCase

  def test_index
    FactoryGirl.create(:serverspec_report)
    get :index, {}, set_session_user
    assert_response :success
    assert_not_nil assigns('serverspec_reports')
    assert_template 'index'
  end

  def test_show
    report = FactoryGirl.create(:serverspec_report)
    get :show, {:id => report.id}, set_session_user
    assert_template 'show'
  end

  test '404 on show when id is blank' do
    get :show, {:id => ' '}, set_session_user
    assert_response :missing
    assert_template 'common/404'
  end

  test '404 on last when no reports available' do
    get :show, { :id => 'last', :host_id => FactoryGirl.create(:host) }, set_session_user
    assert_response :missing
    assert_template 'common/404'
  end

  def test_render_404_when_invalid_report_for_a_host_is_requested
    get :show, {:id => "last", :host_id => "blalala.domain.com"}, set_session_user
    assert_response :missing
    assert_template 'common/404'
  end

  def test_destroy
    report = FactoryGirl.create(:serverspec_report)
    delete :destroy, {:id => report}, set_session_user
    assert_redirected_to serverspec_reports_url
    assert !ServerspecReport.exists?(report.id)
  end

  test "should show report" do
    create_a_report
    assert @report.save!

    get :show, {:id => @report.id}, set_session_user
    assert_response :success
  end

  test "should destroy report" do
    create_a_report
    assert @report.save!

    assert_difference('ServerspecReport.count', -1) do
      delete :destroy, {:id => @report.id}, set_session_user
    end

    assert_redirected_to serverspec_reports_path
  end

  private

  def create_a_report
    @report = ServerspecReport.import(read_json_fixture('reports/empty.json'))
  end
end
