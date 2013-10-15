/** Define the versioned identifiers. */
package id;
import intense.*;
public class VarLangs {

  public ContextDomain dom = new ContextDomain();
  public void bindVar(String value, String version) throws IntenseException {
    Version binder = new Version(value);
    binder.parse(version);
    dom.insert(binder);
  }

  public String bestVar(String version) throws IntenseException {    
    Context requestedContext = new Context();
    requestedContext.parse(version);
    Version bestFitBinder = (Version)(dom.best(requestedContext));
    return ((String)(bestFitBinder.bound)); 
  }
}


