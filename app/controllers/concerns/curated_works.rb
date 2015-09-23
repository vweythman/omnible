# Curated Methods
# ================================================================================

module CuratedWorks

  def index
    find_works

    @works = WorksCurationDecorator.decorate(@works)
    @works.set_parent @parent.decorate

    render 'works/index'
  end

  def find_works
    @works = @parent.works.with_filters(index_params, current_user)
  end

end