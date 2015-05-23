//From http://forum.processing.org/one/topic/loading-data-from-internet-json.html

//A way to solve of getting the flickr data from encountering main thread errors.


// the thread class:

public class ThreadThing implements Runnable {
  Thread thread;

  public ThreadThing(PApplet parent) {
    parent.registerDispose(this);
  }

  public void start() {
    thread = new Thread(this);
    thread.start();
  }

  public void run() {
    // do something threaded here
    getFlickrData();
  }

  public void stop() {
    thread = null;
  }

  // this will magically be called by the parent once the user hits stop
  // this functionality hasn't been tested heavily so if it doesn't work, file a bug
  public void dispose() {
    stop();
  }
}
