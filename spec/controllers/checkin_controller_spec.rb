# frozen_string_literal: true

require 'rails_helper'

describe CheckinController do
  before do
    # set precondition: sessions, datetime, checkin records
    @stu = FactoryBot.create :student
    @expected_time = DateTime.parse('2022-03-08T12:00:00-08:00')
    Timecop.freeze(@expected_time)
    controller.session[:current_user_id] = @stu.id
    @n_checkin_before = Checkin.all.size
  end

  describe 'POST create' do
    describe ': happy path: ' do
      before do
        controller.session[:current_user_id] = @stu.id
        post :create, params: { checkin: { reason: 'Studying' } }
        @new_checkin = Checkin.order(id: :desc).first
      end

      it 'should add 1 new checkin record to the table' do
        expect(Checkin.all.size).to eq(@n_checkin_before + 1)
      end

      it 'should create a checkin record with correct time' do
        expect(@new_checkin.time).to eq(@expected_time)
      end

      it 'the new checkin record should belongs to the student in session' do
        expect(@new_checkin.student).to eq(@stu)
      end

      it 'should clear flash when creating a new checkin' do
        flash[:alert] = 'This is an alert'
        get :new
        expect(flash).to be_empty
      end
    end

    describe ': sad path: ' do
      it "should redirect user to login if the user haven't log in" do
        controller.session[:current_user_id] = nil
        post :create, params: { checkin: { reason: 'Studying' } }
        expect(response).to redirect_to root_path
      end

      it 'should redirect user to landing page if record is not valid' do
        controller.session[:current_user_id] = @stu.id
        post :create, params: { checkin: { reason: nil } }
        expect(response).to redirect_to root_path
        expect(flash[:error]).to match(/Something went wrong, please try again/)
      end
    end
  end

  describe 'autofill functionality' do
    before do
      @student = FactoryBot.create :student
      controller.session[:current_user_id] = @student.id
    end

    context 'when user has no previous check-ins' do
      it 'sets default reason to Peer Support' do
        get :new
        expect(assigns(:default_reason)).to eq('Peer Support')
      end
    end

    context 'when user has previous check-ins' do
      before do
        Checkin.create!(student: @student, reason: 'Studying', time: Time.current)
      end

      it 'sets default reason to last used reason' do
        get :new
        expect(assigns(:default_reason)).to eq('Studying')
      end
    end
  end
end
