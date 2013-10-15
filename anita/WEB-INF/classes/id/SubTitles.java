/** This is supposedly a bean to initialize the versioned
    identifiers, with application scope; the initial value 
    of the lgIn dimension is "en". 
 */

package id;
import intense.*;

public class SubTitles implements java.io.Serializable {

  // Properties
  private String langValue;
  private VarLangs language = new VarLangs();
  private VarLangs languageEn = new VarLangs();
  private VarLangs languageFr = new VarLangs();
  private VarLangs languageEs = new VarLangs();
  private VarLangs languageFa = new VarLangs();
  private VarLangs languageHi = new VarLangs();
  private VarLangs languageMl = new VarLangs();
  private VarLangs languageTa = new VarLangs();
  private VarLangs title = new VarLangs();

// Start new
  private VarLangs userId = new VarLangs();
  private VarLangs youAre = new VarLangs();
  private VarLangs connected = new VarLangs();

  private VarLangs yesFrame = new VarLangs();
  private VarLangs noFrame = new VarLangs();

  private VarLangs switchSideS = new VarLangs();
//  private VarLangs on = new VarLangs();
//  private VarLangs off = new VarLangs();
  private VarLangs frameOnly = new VarLangs();

  private VarLangs pageColor = new VarLangs();
  private VarLangs text = new VarLangs();
  private VarLangs background = new VarLangs();
  private VarLangs black = new VarLangs();
  private VarLangs white = new VarLangs();
  private VarLangs pink = new VarLangs();
  private VarLangs ltGreen = new VarLangs();
  private VarLangs wSize = new VarLangs();
  private VarLangs wLocation = new VarLangs();
  private VarLangs width = new VarLangs();
  private VarLangs height = new VarLangs();

  private VarLangs projection = new VarLangs();
  private VarLangs rivers = new VarLangs();
  private VarLangs rivAndCanals = new VarLangs();
  private VarLangs permRivers = new VarLangs();
  private VarLangs interRivers = new VarLangs();
  private VarLangs canals = new VarLangs();
// End new

  private VarLangs updateMapValue = new VarLangs();
  private VarLangs intro = new VarLangs();
  private VarLangs share = new VarLangs();
  private VarLangs leadFollow = new VarLangs();
  private VarLangs shareSome = new VarLangs();
  private VarLangs shareAll = new VarLangs();
  private VarLangs yes = new VarLangs();
  private VarLangs no = new VarLangs();
  private VarLangs change = new VarLangs();
  private VarLangs langInterface = new VarLangs();
  private VarLangs langMap = new VarLangs();
  private VarLangs noLabels = new VarLangs();
  private VarLangs zoom = new VarLangs();
  private VarLangs zoomIn = new VarLangs();
  private VarLangs zoomOut = new VarLangs();
  private VarLangs noZoom = new VarLangs();
  private VarLangs landColor = new VarLangs();
  private VarLangs waterColor = new VarLangs();
  private VarLangs switchColor = new VarLangs();
  private VarLangs switchGrey = new VarLangs();
  private VarLangs noColor = new VarLangs();
  private VarLangs red = new VarLangs();
  private VarLangs blue = new VarLangs();
  private VarLangs green = new VarLangs();
  private VarLangs grey = new VarLangs();
  private VarLangs spacing = new VarLangs();
  private VarLangs label = new VarLangs();
  private VarLangs frame = new VarLangs();
  private VarLangs grid = new VarLangs();
  private VarLangs region = new VarLangs();
  private VarLangs north = new VarLangs();
  private VarLangs west = new VarLangs();
  private VarLangs east = new VarLangs();
  private VarLangs south = new VarLangs();
  private VarLangs coastlines = new VarLangs();
  private VarLangs nCoastlines = new VarLangs();
  private VarLangs boundary = new VarLangs();
  private VarLangs none = new VarLangs();
  private VarLangs national = new VarLangs();
  private VarLangs state = new VarLangs();
  private VarLangs marine = new VarLangs();
  private VarLangs detail = new VarLangs();
  private VarLangs crude = new VarLangs();
  private VarLangs low = new VarLangs();
  private VarLangs medium = new VarLangs();
  private VarLangs high = new VarLangs();
  private VarLangs full = new VarLangs();
  private VarLangs psView = new VarLangs();
  private VarLangs psView2 = new VarLangs();
  private VarLangs toBegin = new VarLangs();

  // Constructor: initializes the versioned variables
  // Sets the initial language to English
  public SubTitles() throws IntenseException {
    langValue = "en";

    language.bindVar("English","<lg:en>");
    language.bindVar("Fran&ccedil;ais","<lg:fr>");
    language.bindVar("Espa&ntilde;ol","<lg:es>");

    languageEn.bindVar("English","<lg:en>");
    languageEn.bindVar("Anglais","<lg:fr>");
    languageEn.bindVar("Ingl&eacute;s","<lg:es>");

    languageFr.bindVar("French","<lg:en>");
    languageFr.bindVar("Fran&ccedil;ais","<lg:fr>");
    languageFr.bindVar("Franc&eacute;s","<lg:es>");

    languageEs.bindVar("Spanish","<lg:en>");
    languageEs.bindVar("Espagnol","<lg:fr>");
    languageEs.bindVar("Espa&ntilde;ol","<lg:es>");

    languageFa.bindVar("Farsi","<lg:en>");
    languageFa.bindVar("Farsi","<lg:fr>");
    languageFa.bindVar("Farsi","<lg:es>");

    languageHi.bindVar("Hindi","<lg:en>");
    languageHi.bindVar("Hindi","<lg:fr>");
    languageHi.bindVar("Hindi","<lg:es>");

    languageMl.bindVar("Malayalam","<lg:en>");
    languageMl.bindVar("Malayalame","<lg:fr>");
    languageMl.bindVar("Malayalamo","<lg:es>");

    languageTa.bindVar("Tamil","<lg:en>");
    languageTa.bindVar("Tamil","<lg:fr>");
    languageTa.bindVar("Tamil","<lg:es>");

    title.bindVar("Anita Conti Mapping Server","<lg:en>");
    title.bindVar("Serveur de Cartes G&eacute;o Anita Conti","<lg:fr>");
    title.bindVar("Servidor de mapas Anita Conti","<lg:es>");

// Start new

    userId.bindVar("Your User Id is","<lg:en>");
    userId.bindVar("Votre num&eacute;ro est","<lg:fr>");
    userId.bindVar("Su n&uacute;mero de usuario es","<lg:es>");

    youAre.bindVar("and you are","<lg:en>");
    youAre.bindVar("et vous &ecirc;tes","<lg:fr>");
    youAre.bindVar("y usted es","<lg:es>");

    connected.bindVar("You are connected to","<lg:en>");
    connected.bindVar("Vous &ecirc;tes connect&eacute; &agrave","<lg:fr>");
    connected.bindVar("Usted est&aacute; conectado a","<lg:es>");

    yesFrame.bindVar("No map frame","<lg:en>");
    yesFrame.bindVar("Carte sans cadre","<lg:fr>");
    yesFrame.bindVar("Mapa sin marco","<lg:es>");

    noFrame.bindVar("Add a map frame","<lg:en>");
    noFrame.bindVar("Carte avec cadre","<lg:fr>");
    noFrame.bindVar("Mapa con marco","<lg:es>");

    switchSideS.bindVar("Switch settings for map border","<lg:en>");
    switchSideS.bindVar("Changer les r&eacute;glages de la bordure","<lg:fr>");
    switchSideS.bindVar("Cambiar ajustes de la margen","<lg:es>");

    frameOnly.bindVar("Frame only","<lg:en>");
    frameOnly.bindVar("Cadre seulement","<lg:fr>");
    frameOnly.bindVar("Marco solamente","<lg:es>");

    pageColor.bindVar("Web page color","<lg:en>");
    pageColor.bindVar("Couleur de la page","<lg:fr>");
    pageColor.bindVar("Color de la p&aacute;gina","<lg:es>");

    text.bindVar("Text","<lg:en>");
    text.bindVar("Texte","<lg:fr>");
    text.bindVar("Texto","<lg:es>");

    background.bindVar("Background","<lg:en>");
    background.bindVar("Fond","<lg:fr>");
    background.bindVar("Fondo","<lg:es>");

    black.bindVar("Black","<lg:en>");
    black.bindVar("Noir","<lg:fr>");
    black.bindVar("Negro","<lg:es>");

    white.bindVar("White","<lg:en>");
    white.bindVar("Blanc","<lg:fr>");
    white.bindVar("Blanco","<lg:es>");

    pink.bindVar("Pink","<lg:en>");
    pink.bindVar("Rose","<lg:fr>");
    pink.bindVar("Rosado","<lg:es>");

    ltGreen.bindVar("Light Green","<lg:en>");
    ltGreen.bindVar("Vert Clair","<lg:fr>");
    ltGreen.bindVar("Verde Claro","<lg:es>");

    wSize.bindVar("Window Size","<lg:en>");
    wSize.bindVar("Taille de la Fen&ecirc;tre","<lg:fr>");
    wSize.bindVar("Talla de la Ventana","<lg:es>");

    wLocation.bindVar("Window Location (UL)","<lg:en>");
    wLocation.bindVar("Position de la Fen&ecirc;tre","<lg:fr>");
    wLocation.bindVar("Posici&oacute;n de la Ventana","<lg:es>");

    width.bindVar("Width","<lg:en>");
    width.bindVar("Largeur","<lg:fr>");
    width.bindVar("Ancho","<lg:es>");

    height.bindVar("Height","<lg:en>");
    height.bindVar("Hauteur","<lg:fr>");
    height.bindVar("Altura","<lg:es>");

    projection.bindVar("Projection","<lg:en>");
    projection.bindVar("Projection","<lg:fr>");
    projection.bindVar("Proyecci&oacute;n","<lg:es>");

    rivers.bindVar("Rivers","<lg:en>");
    rivers.bindVar("Rivi&egrave;res","<lg:fr>");
    rivers.bindVar("R&iacute;os","<lg:es>");

    rivAndCanals.bindVar("Rivers and Canals","<lg:en>");
    rivAndCanals.bindVar("Rivi&egrave;res et Canaux","<lg:fr>");
    rivAndCanals.bindVar("R&iacute;os y Canales","<lg:es>");

    permRivers.bindVar("Permanet Rivers","<lg:en>");
    permRivers.bindVar("Rivi&egrave;res Permanantes","<lg:fr>");
    permRivers.bindVar("R&iacute;os Permanentes","<lg:es>");

    interRivers.bindVar("Intermitent Rivers","<lg:en>");
    interRivers.bindVar("Rivi&egrave;res Intermitantes","<lg:fr>");
    interRivers.bindVar("R&iacute;os Intermitentes","<lg:es>");

    canals.bindVar("Canals","<lg:en>");
    canals.bindVar("Canaux","<lg:fr>");
    canals.bindVar("Canales","<lg:es>");

//    height.bindVar("","<lg:en>");
//    height.bindVar("","<lg:fr>");
//    height.bindVar("","<lg:es>");


// End new

    updateMapValue.bindVar("Update Map","<lg:en>");
    updateMapValue.bindVar("Actualiser la carte","<lg:fr>");
    updateMapValue.bindVar("Actualizar el mapa","<lg:es>");

    intro.bindVar("Introduction","<lg:en>");
    intro.bindVar("Introduction","<lg:fr>");
    intro.bindVar("Introducci&oacute;n","<lg:es>");

    share.bindVar("Sharing","<lg:en>");
    share.bindVar("Partage","<lg:fr>");
    share.bindVar("Compartir","<lg:es>");

    leadFollow.bindVar("Lead-Follow","<lg:en>");
    leadFollow.bindVar("Guider-Suivre","<lg:fr>");
    leadFollow.bindVar("Gu&iacute;a-Seguidor","<lg:es>");

    shareSome.bindVar("Share some","<lg:en>");
    shareSome.bindVar("Semi-partage","<lg:fr>");
    shareSome.bindVar("Compartir algo","<lg:es>");

    shareAll.bindVar("Share All","<lg:en>");
    shareAll.bindVar("Tout partager","<lg:fr>");
    shareAll.bindVar("Compartir todo","<lg:es>");

    yes.bindVar("Yes","<lg:en>");
    yes.bindVar("Oui","<lg:fr>");
    yes.bindVar("Si","<lg:es>");

    no.bindVar("No","<lg:en>");
    no.bindVar("Non","<lg:fr>");
    no.bindVar("No","<lg:es>");

    change.bindVar("Modify","<lg:en>");
    change.bindVar("Modifier","<lg:fr>");
    change.bindVar("Cambiar","<lg:es>");

    langInterface.bindVar("Interface language","<lg:en>");
    langInterface.bindVar("Langue de l'interface","<lg:fr>");
    langInterface.bindVar("Idioma de la Interface","<lg:es>");

    langMap.bindVar("Map language","<lg:en>");
    langMap.bindVar("Langue de la carte","<lg:fr>");
    langMap.bindVar("Idioma del Mapa","<lg:es>");

    noLabels.bindVar("No names","<lg:en>");
    noLabels.bindVar("Pas de noms","<lg:fr>");
    noLabels.bindVar("Sin nombres","<lg:es>");

    zoom.bindVar("Zooming level","<lg:en>");
    zoom.bindVar("Niveau de zooming","<lg:fr>");
    zoom.bindVar("Nivel de zooming","<lg:es>");

    zoomIn.bindVar("Zoom in","<lg:en>");
    zoomIn.bindVar("Agrandir","<lg:fr>");
    zoomIn.bindVar("Acercar","<lg:es>");

    zoomOut.bindVar("Zoom out","<lg:en>");
    zoomOut.bindVar("Reduire","<lg:fr>");
    zoomOut.bindVar("Alejar","<lg:es>");

    noZoom.bindVar("Change map center","<lg:en>");
    noZoom.bindVar("Changer le centre","<lg:fr>");
    noZoom.bindVar("Cambiar el centro","<lg:es>");

    landColor.bindVar("Land Color","<lg:en>");
    landColor.bindVar("Couleur de la Terre","<lg:fr>");
    landColor.bindVar("Color de la Tierra","<lg:es>");

    waterColor.bindVar("Water Color","<lg:en>");
    waterColor.bindVar("Couleur de l'eau","<lg:fr>");
    waterColor.bindVar("Color del Agua","<lg:es>");

    switchColor.bindVar("Switch to color","<lg:en>");
    switchColor.bindVar("Couleur","<lg:fr>");
    switchColor.bindVar("Color","<lg:es>");

    switchGrey.bindVar("Switch to grey","<lg:en>");
    switchGrey.bindVar("Niveau de gris","<lg:fr>");
    switchGrey.bindVar("Nivel de gris","<lg:es>");

    noColor.bindVar("No color","<lg:en>");
    noColor.bindVar("Sans couleur","<lg:fr>");
    noColor.bindVar("Sin color","<lg:es>");

    red.bindVar("Red","<lg:en>");
    red.bindVar("Rouge","<lg:fr>");
    red.bindVar("Rojo","<lg:es>");

    blue.bindVar("Blue","<lg:en>");
    blue.bindVar("Blue","<lg:fr>");
    blue.bindVar("Azul","<lg:es>");

    green.bindVar("Green","<lg:en>");
    green.bindVar("Vert","<lg:fr>");
    green.bindVar("Verde","<lg:es>");

    grey.bindVar("Grey","<lg:en>");
    grey.bindVar("Gris","<lg:fr>");
    grey.bindVar("Gris","<lg:es>");

    spacing.bindVar("Axis spacing in","<lg:en>");
    spacing.bindVar("S&eacute;paration en l'axe en","<lg:fr>");
    spacing.bindVar("Separaci&oacute;n del axis en","<lg:es>");

    label.bindVar("Label","<lg:en>");
    label.bindVar("&Eacute;tiquette","<lg:fr>");
    label.bindVar("Etiqueta","<lg:es>");

    frame.bindVar("Frame","<lg:en>");
    frame.bindVar("Cadre","<lg:fr>");
    frame.bindVar("Marco","<lg:es>");

    grid.bindVar("Grid","<lg:en>");
    grid.bindVar("Grille","<lg:fr>");
    grid.bindVar("Rejilla","<lg:es>");

    region.bindVar("Region","<lg:en>");
    region.bindVar("R&eacute;gion","<lg:fr>");
    region.bindVar("Regi&oacute;n","<lg:es>");

    north.bindVar("North","<lg:en>");
    north.bindVar("Nord","<lg:fr>");
    north.bindVar("Norte","<lg:es>");

    west.bindVar("West","<lg:en>");
    west.bindVar("Ouest","<lg:fr>");
    west.bindVar("Oeste","<lg:es>");

    east.bindVar("East","<lg:en>");
    east.bindVar("Est","<lg:fr>");
    east.bindVar("Este","<lg:es>");

    south.bindVar("South","<lg:en>");
    south.bindVar("Sud","<lg:fr>");
    south.bindVar("Sur","<lg:es>");

    coastlines.bindVar("Include coastlines","<lg:en>");
    coastlines.bindVar("Inclure les limites litorales","<lg:fr>");
    coastlines.bindVar("Incluir los l&iacute;mites litorales","<lg:es>");

    nCoastlines.bindVar("No coastline borders","<lg:en>");
    nCoastlines.bindVar("Pas de limites litorales","<lg:fr>");
    nCoastlines.bindVar("Sin l&iacute;mites litorales","<lg:es>");

    boundary.bindVar("Boundary","<lg:en>");
    boundary.bindVar("Fronti&egrave;res","<lg:fr>");
    boundary.bindVar("Divisi&oacute;n pol&iacute;tica","<lg:es>");

    none.bindVar("None","<lg:en>");
    none.bindVar("Rien","<lg:fr>");
    none.bindVar("Nada","<lg:es>");

    national.bindVar("National","<lg:en>");
    national.bindVar("Nationales","<lg:fr>");
    national.bindVar("Nacional","<lg:es>");

    state.bindVar("State (Americas)","<lg:en>");
    state.bindVar("&Eacute;tat (Am&eacute;riques)","<lg:fr>");
    state.bindVar("Estatal (Am&eacute;rica)","<lg:es>");

    marine.bindVar("Marine","<lg:en>");
    marine.bindVar("Maritimes","<lg:fr>");
    marine.bindVar("Mar&iacute;tima","<lg:es>");

    detail.bindVar("Level of detail","<lg:en>");
    detail.bindVar("Niveau de d&eacute;tail","<lg:fr>");
    detail.bindVar("Nivel de detalle","<lg:es>");

    crude.bindVar("Crude","<lg:en>");
    crude.bindVar("Brut","<lg:fr>");
    crude.bindVar("Crudo","<lg:es>");

    low.bindVar("Low","<lg:en>");
    low.bindVar("Bas","<lg:fr>");
    low.bindVar("Bajo","<lg:es>");

    medium.bindVar("Medium","<lg:en>");
    medium.bindVar("Moyen","<lg:fr>");
    medium.bindVar("Mediano","<lg:es>");

    high.bindVar("High","<lg:en>");
    high.bindVar("Haut","<lg:fr>");
    high.bindVar("Alto","<lg:es>");

    full.bindVar("Full","<lg:en>");
    full.bindVar("Maximum","<lg:fr>");
    full.bindVar("M&aacute;ximo","<lg:es>");

    psView.bindVar("PostScript format ","<lg:en>");
    psView.bindVar("Format PostScript ","<lg:fr>");
    psView.bindVar("Formato PostScript ","<lg:es>");

    psView2.bindVar("To view the PostScript form of the file press" +
                   " (or to download shift-press)","<lg:en>");
    psView2.bindVar("Pour la version PostScript de la carte pousser" +
                   " (ou pour telecharger shift-pousser)","<lg:fr>");
    psView2.bindVar("Para obtener la version PostScript presione" +
                   " (o shift-presione)","<lg:es>");

    toBegin.bindVar("To begin ","<lg:en>");
    toBegin.bindVar("Pour commencer ","<lg:fr>");
    toBegin.bindVar("Para comenzar ","<lg:es>");

  }


  // Private classes to create a domain containing versioned strings
  private class VarLangs {
    private ContextDomain dom = new ContextDomain();
    private void bindVar(String value, String version) throws IntenseException
    {
      Version binder = new Version(value);
      binder.parse(version);
      dom.insert(binder);
    }

    private String bestVar(String version) throws IntenseException {    
      Context requestedContext = new Context();
      requestedContext.parse(version);
      Version bestFitBinder = (Version)(dom.best(requestedContext));
      return ((String)(bestFitBinder.bound)); 
    }
  }

  // Setter for the langValue property. The only setter of the bean
  public void setLangValue(String langValue) {
    this.langValue = langValue;
  }

  // All the getters of the other properties ie, the versioned strings
  public String getLanguage() throws IntenseException {
    return language.bestVar("<lg:" + langValue + ">");
  }

  public String getLanguageEn() throws IntenseException {
    return languageEn.bestVar("<lg:" + langValue + ">");
  }

  public String getLanguageFr() throws IntenseException {
    return languageFr.bestVar("<lg:" + langValue + ">");
  }

  public String getLanguageEs() throws IntenseException {
    return languageEs.bestVar("<lg:" + langValue + ">");
  }

  public String getLanguageFa() throws IntenseException {
    return languageFa.bestVar("<lg:" + langValue + ">");
  }

  public String getLanguageHi() throws IntenseException {
    return languageHi.bestVar("<lg:" + langValue + ">");
  }

  public String getLanguageMl() throws IntenseException {
    return languageMl.bestVar("<lg:" + langValue + ">");
  }

  public String getLanguageTa() throws IntenseException {
    return languageTa.bestVar("<lg:" + langValue + ">");
  }

  public String getTitle() throws IntenseException {
    return title.bestVar("<lg:" + langValue + ">");
  }

// Start new


  public String getUserId() throws IntenseException {
    return userId.bestVar("<lg:" + langValue + ">");
  }

  public String getYouAre() throws IntenseException {
    return youAre.bestVar("<lg:" + langValue + ">");
  }

  public String getConnected() throws IntenseException {
    return connected.bestVar("<lg:" + langValue + ">");
  }

  public String getYesFrame() throws IntenseException {
    return yesFrame.bestVar("<lg:" + langValue + ">");
  }

  public String getNoFrame() throws IntenseException {
    return noFrame.bestVar("<lg:" + langValue + ">");
  }

  public String getFrameOnly() throws IntenseException {
    return frameOnly.bestVar("<lg:" + langValue + ">");
  }

  public String getPageColor() throws IntenseException {
    return pageColor.bestVar("<lg:" + langValue + ">");
  }

  public String getText() throws IntenseException {
    return text.bestVar("<lg:" + langValue + ">");
  }

  public String getBackground() throws IntenseException {
    return background.bestVar("<lg:" + langValue + ">");
  }

  public String getBlack() throws IntenseException {
    return black.bestVar("<lg:" + langValue + ">");
  }

  public String getWhite() throws IntenseException {
    return white.bestVar("<lg:" + langValue + ">");
  }

  public String getPink() throws IntenseException {
    return pink.bestVar("<lg:" + langValue + ">");
  }

  public String getLtGreen() throws IntenseException {
    return ltGreen.bestVar("<lg:" + langValue + ">");
  }

  public String getWSize() throws IntenseException {
    return wSize.bestVar("<lg:" + langValue + ">");
  }

  public String getWLocation() throws IntenseException {
    return wLocation.bestVar("<lg:" + langValue + ">");
  }

  public String getWidth() throws IntenseException {
    return width.bestVar("<lg:" + langValue + ">");
  }

  public String getHeight() throws IntenseException {
    return height.bestVar("<lg:" + langValue + ">");
  }

  public String getSwitchSideS() throws IntenseException {
    return switchSideS.bestVar("<lg:" + langValue + ">");
  }

  public String getProjection() throws IntenseException {
    return projection.bestVar("<lg:" + langValue + ">");
  }

  public String getRivers() throws IntenseException {
    return rivers.bestVar("<lg:" + langValue + ">");
  }

  public String getRivAndCanals() throws IntenseException {
    return rivAndCanals.bestVar("<lg:" + langValue + ">");
  }

  public String getPermRivers() throws IntenseException {
    return permRivers.bestVar("<lg:" + langValue + ">");
  }

  public String getInterRivers() throws IntenseException {
    return interRivers.bestVar("<lg:" + langValue + ">");
  }

  public String getCanals() throws IntenseException {
    return canals.bestVar("<lg:" + langValue + ">");
  }

//  public String get() throws IntenseException {
//    return .bestVar("<lg:" + langValue + ">");
//  }



// End new


  public String getUpdateMapValue() throws IntenseException {
    return updateMapValue.bestVar("<lg:" + langValue + ">");
  }

  public String getIntro() throws IntenseException {
    return intro.bestVar("<lg:" + langValue + ">");
  }

  public String getShare() throws IntenseException {
    return share.bestVar("<lg:" + langValue + ">");
  }

  public String getLeadFollow() throws IntenseException {
    return leadFollow.bestVar("<lg:" + langValue + ">");
  }

  public String getShareSome() throws IntenseException {
    return shareSome.bestVar("<lg:" + langValue + ">");
  }

  public String getShareAll() throws IntenseException {
    return shareAll.bestVar("<lg:" + langValue + ">");
  }

  public String getYes() throws IntenseException {
    return yes.bestVar("<lg:" + langValue + ">");
  }

  public String getNo() throws IntenseException {
    return no.bestVar("<lg:" + langValue + ">");
  }

  public String getChange() throws IntenseException {
    return change.bestVar("<lg:" + langValue + ">");
  }

  public String getLangInterface() throws IntenseException {
    return langInterface.bestVar("<lg:" + langValue + ">");
  }

  public String getLangMap() throws IntenseException {
    return langMap.bestVar("<lg:" + langValue + ">");
  }

  public String getNoLabels() throws IntenseException {
    return noLabels.bestVar("<lg:" + langValue + ">");
  }

  public String getZoom() throws IntenseException {
    return zoom.bestVar("<lg:" + langValue + ">");
  }

  public String getZoomIn() throws IntenseException {
    return zoomIn.bestVar("<lg:" + langValue + ">");
  }

  public String getZoomOut() throws IntenseException {
    return zoomOut.bestVar("<lg:" + langValue + ">");
  }

  public String getNoZoom() throws IntenseException {
    return noZoom.bestVar("<lg:" + langValue + ">");
  }

  public String getLandColor() throws IntenseException {
    return landColor.bestVar("<lg:" + langValue + ">");
  }

  public String getWaterColor() throws IntenseException {
    return waterColor.bestVar("<lg:" + langValue + ">");
  }

  public String getSwitchColor() throws IntenseException {
    return switchColor.bestVar("<lg:" + langValue + ">");
  }

  public String getSwitchGrey() throws IntenseException {
    return switchGrey.bestVar("<lg:" + langValue + ">");
  }

  public String getNoColor() throws IntenseException {
    return noColor.bestVar("<lg:" + langValue + ">");
  }

  public String getRed() throws IntenseException {
    return red.bestVar("<lg:" + langValue + ">");
  }

  public String getBlue() throws IntenseException {
    return blue.bestVar("<lg:" + langValue + ">");
  }

  public String getGreen() throws IntenseException {
    return green.bestVar("<lg:" + langValue + ">");
  }

  public String getGrey() throws IntenseException {
    return grey.bestVar("<lg:" + langValue + ">");
  }

  public String getSpacing() throws IntenseException {
    return spacing.bestVar("<lg:" + langValue + ">");
  }

  public String getLabel() throws IntenseException {
    return label.bestVar("<lg:" + langValue + ">");
  }

  public String getFrame() throws IntenseException {
    return frame.bestVar("<lg:" + langValue + ">");
  }

  public String getGrid() throws IntenseException {
    return grid.bestVar("<lg:" + langValue + ">");
  }

  public String getRegion() throws IntenseException {
    return region.bestVar("<lg:" + langValue + ">");
  }

  public String getNorth() throws IntenseException {
    return north.bestVar("<lg:" + langValue + ">");
  }

  public String getWest() throws IntenseException {
    return west.bestVar("<lg:" + langValue + ">");
  }

  public String getEast() throws IntenseException {
    return east.bestVar("<lg:" + langValue + ">");
  }

  public String getSouth() throws IntenseException {
    return south.bestVar("<lg:" + langValue + ">");
  }

  public String getCoastlines() throws IntenseException {
    return coastlines.bestVar("<lg:" + langValue + ">");
  }

  public String getNCoastlines() throws IntenseException {
    return nCoastlines.bestVar("<lg:" + langValue + ">");
  }

  public String getBoundary() throws IntenseException {
    return boundary.bestVar("<lg:" + langValue + ">");
  }

  public String getNone() throws IntenseException {
    return none.bestVar("<lg:" + langValue + ">");
  }

  public String getNational() throws IntenseException {
    return national.bestVar("<lg:" + langValue + ">");
  }

  public String getState() throws IntenseException {
    return state.bestVar("<lg:" + langValue + ">");
  }

  public String getMarine() throws IntenseException {
    return marine.bestVar("<lg:" + langValue + ">");
  }

  public String getDetail() throws IntenseException {
    return detail.bestVar("<lg:" + langValue + ">");
  }

  public String getCrude() throws IntenseException {
    return crude.bestVar("<lg:" + langValue + ">");
  }

  public String getLow() throws IntenseException {
    return low.bestVar("<lg:" + langValue + ">");
  }

  public String getMedium() throws IntenseException {
    return medium.bestVar("<lg:" + langValue + ">");
  }

  public String getHigh() throws IntenseException {
    return high.bestVar("<lg:" + langValue + ">");
  }

  public String getFull() throws IntenseException {
    return full.bestVar("<lg:" + langValue + ">");
  }

  public String getPsView() throws IntenseException {
    return psView.bestVar("<lg:" + langValue + ">");
  }

  public String getToBegin() throws IntenseException {
    return toBegin.bestVar("<lg:" + langValue + ">");
  }

// THE END
}

