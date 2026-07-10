class PrintsController < ApplicationController
  after_action :log_activity, only: %i[show]

  def show
    @post = Post.find(params[:post_id])
    html = render_to_string(template: "prints/show", layout: false)

    grover = Grover.new(html,
      format: "A4",
      margin: { top: "20px", bottom: "20px" },
      print_background: true,
      display_url: "http://127.0.0.1:3000",
      prefer_file_to_url: true,
      launch_args: [ "--allow-file-access-from-files", "--disable-web-security" ]
    )
    pdf = grover.to_pdf

    send_data pdf,
      filename: "#{@post.title}-print.pdf",
      type: "application/pdf",
      disposition: "inline"
  end
end
