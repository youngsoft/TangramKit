#
#  Be sure to run `pod spec lint TangramKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "TangramKit"
  s.version      = "1.4.0"
  s.summary      = "TangramKit is A powerful iOS UI framework. It integrated the Android layout,AutoLayout,SizeClass, HTML/CSS float and flexbox functions."

  s.description  = <<-DESC
                   *TangramKit is a powerful iOS UI layout framework which is not an encapsulation based on the AutoLayout but is based on primary frame property and by overwriting the layoutSubview method to realize the subview's layout. 
                   *So It is unlimited to run in any version of iOS system. 
                   *Its idea and principle is referenced from the layout of the Android system, HTML/CSS float&flexbox, iOS AutoLayout and SizeClass. 
                   *You can implement the UI layout through the seven kinds of layout class below: TGLinearLayout, TGRelativeLayout, TGFrameLayout TGTableLayout, TGFlowLayout,TGFloatLayout and the support for SizeClass.
                   *Powerful function, easy to use, barely constraint setting and fit various screen size perfectly are MyLayout's main advantages.
                   *I hope you use TangramKit right now or in your next project will be happy!.
                   DESC

  s.homepage     = "https://github.com/youngsoft/TangramKit"
  s.screenshots  = "http://upload-images.jianshu.io/upload_images/1432482-3bfd0855a51b6d8e.gif?imageMogr2/auto-orient/strip"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  s.author             = { "欧阳大哥" => "obq0387_cn@sina.com" }
  # Or just: s.author    = "欧阳大哥"
  # s.authors            = { "欧阳大哥" => "obq0387_cn@sina.com" }
  # s.social_media_url   = "http://blog.csdn.net/yangtiang"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # s.platform     = :ios
  s.platform     = :ios, "8.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "https://github.com/youngsoft/TangramKit.git", :tag => s.version }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  s.source_files  = "TangramKit/*.{swift}"
  #s.exclude_files = "Classes/Exclude"


end
