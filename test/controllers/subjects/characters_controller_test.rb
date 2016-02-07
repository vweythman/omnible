require 'test_helper'

module Subjects
  class CharactersControllerTest < ControllerTestCase

    # SETUP
    # ============================================================
    setup do
      @mary = characters(:mary)
      @jane = characters(:jane)
      @erik = characters(:erik)

      @item     = items(:aegis)
      @identity = identities(:young)

      @roleplay_jane  = characters(:roleplay_jane)
      @roleplay_john  = characters(:roleplay_john)
      @roleplay_allen = characters(:roleplay_allen)

      @sirka = users(:sirka)
      @amiya = users(:amiya)
      @indra = users(:indra)

      @becca = users(:becca)
      @letty = users(:letty)
      @tegan = users(:tegan)
    end

    # GET
    # ============================================================
    # INDEX
    # ------------------------------------------------------------
    test "should get index" do
      get :index

      assert_response :success
      assert_not_nil assigns(:characters)
      assert_not_nil assigns(:subjects)
      assert_equal assigns(:characters), assigns(:subjects)
    end

    # SHOW
    # ------------------------------------------------------------
    test "should show character" do
      get :show, id: @jane

      assert_response :success
      assert_not_nil assigns(:character)
    end

    test "should not show character" do
      sign_in @amiya

      get :show, id: @mary

      assert_redirected_to characters_path
    end

    # NEW
    # ------------------------------------------------------------
    test "should get new" do
      sign_in @amiya

      get :new

      assert_response :success
      assert_not_nil assigns(:character)
      assert_not_nil assigns(:identities)
      assert_not_nil assigns(:items)
      assert_not_nil assigns(:opinions)
      assert_not_nil assigns(:prejudices)
      assert_not_nil assigns(:text)
    end

    test "should not get new" do
      get :new

      assert_redirected_to root_path
    end

    # EDIT
    # ------------------------------------------------------------
    test "should get edit" do
      sign_in @sirka

      get :edit, id: @jane

      assert_response :success
      assert_not_nil assigns(:character)
      assert_not_nil assigns(:identities)
      assert_not_nil assigns(:items)
      assert_not_nil assigns(:opinions)
      assert_not_nil assigns(:prejudices)
      assert_not_nil assigns(:text)
    end

    test "should not get edit" do
      sign_in @amiya

      get :edit, id: @mary

      assert_redirected_to @mary
    end

    # POST
    # ============================================================
    test "should create character" do
      sign_in @letty

      assert_difference('Character.count') do
        post :create, character: {
          name:       'Alice',
          variations: 'Alice of Wonderland;Young Alice',
          editor_level:    Editable::PERSONAL,
          publicity_level: Editable::PUBLIC,
          allow_play:   true,
          allow_clones: true,
          can_connect:  true,
          :describers              => {"age"=>"young;young adult"},
          "details_attributes"     => {"0"=>{"title"=>"History", "content"=>"This is where it all began.", "_destroy"=>"false"}},
          "possessions_attributes" => {"0"=>{item_id: @item.id, nature: "Owns"}},
          "opinions_attributes"    => {"0"=>{fondness: 0, respect: 0, recip_id: @mary.id}},
          "prejudices_attributes"  => {"0"=>{fondness: 0, respect: 0, facet_id: @identity.facet_id, identity_name: @identity.name}},
        }
      end

      assert_redirected_to character_path(assigns(:character))
    end

    # PATCH/PUT
    # ============================================================
    test "should update character" do
      sign_in @sirka

      patch :update, id: @jane, character: { name: @jane.name, editor_level: @jane.editor_level, publicity_level: @jane.editor_level }

      assert_redirected_to @jane
    end

    # DELETE
    # ============================================================
    test "should destroy character" do
      sign_in @amiya
      assert_difference('Character.count', -1) do
        delete :destroy, id: @erik
      end

      assert_redirected_to characters_path
    end

  end
end