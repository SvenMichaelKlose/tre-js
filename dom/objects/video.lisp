(fn make-video-flash (url width height)
  (aprog1 (make-extended-element "object"
                                 (new :classid  "clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
                                      :codebase "http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,0,0"
                                      :width    width
                                      :height   height)
                                 (new :position "absolute"))
    (!.add (make-extended-element "param" (new :name "wmode" :value "opaque")))
    (!.add (make-extended-element "param" (new :name "scale" :value "exactfit")))
    (!.add (make-extended-element "embed" (new :src    url
                                               :width  width
                                               :height height
                                               :type   "application/x-shockwave-flash"
                                               :allowscriptaccess "sameDomain"
                                               :allowfullscreen   "true"
                                               :wmode "opaque"
                                               :scale "exactfit")))))

(fn make-video (&key width height (high nil) (low nil) (webm nil) (swf nil) (loop? nil) (autoplay? nil))
  (let video (make-extended-element "video" (new :width width :height height))
    (when loop?
      (video.write-attribute "loop" "loop")
      (video.write-attribute "onended" "this.play();"))
    (when autoplay?
      (video.write-attribute "autoplay" "autoplay"))
    (? (not high low webm)
       (!? swf
           (make-video-flash ! width height)
           (error "video location missing"))
       (@ (i (+ (!? high `((,! "video/mp4; codecs=\"avc1.4D401F, mp4a.40.2\"")))
                (!? low  `((,! "video/mp4; codecs=\"avc1.42E01E, mp4a.40.2\"")))
                (!? webm `((,! "video/webm"))))
           {(!? swf
                (video.add (make-video-flash ! width height)))
            video})
         (video.add (make-extended-element "source" {:src i. :type .i.}))))))

(fn frame-seconds (frames-per-second x)
  (/ x frames-per-second))

(fn make-video-stopper (video frames-per-second from-frame to-frame)
  (with (int  nil
         end  (frame-seconds frames-per-second to-frame))
    (= int (window.set-interval #'(()
                                     (when (< end video.current-time)
                                       (window.clear-interval int)
                                       (video.pause)
                                       (= video.current-time end)))
                                (/ (/ 1000 frames-per-second) 2)))))

(fn video-wait-while-seeking (video)
  (when (| video.paused video.seeking)
    (do-wait 100
      (video-wait-while-seeking video))))

(defvar *google-chrome-illegal-video-position* 0)

(fn video-play-snippet (&key video frames-per-second from-frame to-frame)
  (| (== *google-chrome-illegal-video-position* from-frame)
     (= video.current-time (frame-seconds frames-per-second from-frame)))
  (video.play)
  (make-video-stopper video frames-per-second from-frame to-frame))
