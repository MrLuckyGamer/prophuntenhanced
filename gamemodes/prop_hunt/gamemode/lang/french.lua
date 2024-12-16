
local LANG = {}

-- Language code and name
LANG.Code = "fr"
LANG.Name = "français"
LANG.NameEnglish = "french"

LANG.Help = [[	Un Prop Hunt Classique amélioré.
Pour afficher l'aide, clique sur 'Menu Prop Hunt'.
	Version: %s
		Nouveautés:
		- Équilibrage des équipes amélioré
		- Un bouton de décoinçage
		- Hauteur des taunts modifiable
		- Et plus encore !

	Traduction originale par lucas2107!
	]]

-- HUD elements
LANG.HUD = {}

LANG.HUD.HEALTH = "SANTÉ"
LANG.HUD.AMMO = "MUNITIONS"
LANG.HUD.TIME = "TEMPS"
LANG.HUD.ROUND = "MANCHE"

LANG.HUD.ROTLOCKON = "Rotation du Prop: Bloquée"
LANG.HUD.ROTLOCKOFF = "Rotation du Prop: Libre"
LANG.HUD.FREEZECAM = "Vous avez été tué par %s"

LANG.HUD.WAIT = "En attente de joueurs..."
LANG.HUD.WIN = "Les %s ont gagné !"
LANG.HUD.DRAW = "Égalité !"

LANG.HUD.BLINDTIME = "Les Hunters seront libérés dans %s"
LANG.HUD.BLINDEND = "Prêt ou non, nous arrivons !"

--  Kill text (X killed Y)
LANG.DEATHNOTICE = {}
LANG.DEATHNOTICE.KILLED = "a tué"

LANG.DEATHNOTICE.SUICIDE = {
	"s'est suicidé !",
	"est mort mystérieusement.",
	"est mort par la magie.",
	"s'est no-scope lui même.",
	"a simplement ragequit.",
	"a trop picolé.",
	"est mort... plus de chance la prochaine fois !",
	"s'est giflé.",
	"a trébuché sur un bâton.",
	"est mort par la force.",
	"ragdolled.",
}

-- Common
LANG.MISC = {}

LANG.MISC.ACCEPT = "Accepter"
LANG.MISC.CLOSE = "Fermer"
LANG.MISC.TIMELEFT = "Temps restant: %s"
LANG.MISC.NOTIMELEFT = "La partie se terminera après cette manche"

-- Derma elements
LANG.DERMA = {}

-- Team selection screen (F2)
LANG.DERMA.TEAMSELECT = "Choisir une équipe"

-- F1 screeen
LANG.DERMA.RTV = "Voter pour changer (RTV)"
LANG.DERMA.PHMENU = "Menu Prop Hunt"
LANG.DERMA.CHANGETEAM = "Changer d'équipe"

-- Scoreboard
LANG.DERMA.PLAYER = "(%d joueur)"
LANG.DERMA.PLAYERS = "(%d joueurs)"
LANG.DERMA.NAME = "Pseudo"
LANG.DERMA.KILLS = "Kills"
LANG.DERMA.DEATHS = "Morts"
LANG.DERMA.PING = "Ping"

-- Chat messages
LANG.CHAT = {}

LANG.CHAT.NOTENOUGHPLYS = "Il n'y a pas assez de joueurs pour commencer une partie !"
LANG.CHAT.SWAP = "Les équipes ont été échangées !"

LANG.CHAT.JOINED = " a rejoint "
LANG.CHAT.JOINEDTHE = " a rejoint les "

LANG.CHAT.RANDOM_SPECTATORS = {
	"pour regarder et se détendre.",
	"pour les voir traîner dans le coin.",
	"pour voir des choses.",
	"",
}

-- PHE Menu (F1 > PHE Menu)
LANG.PHEMENU = {}


LANG.PHEMENU.HELP = {}
LANG.PHEMENU.HELP.TAB = "Aide"

LANG.PHEMENU.MUTE = {}
LANG.PHEMENU.MUTE.TAB = "Mute"
LANG.PHEMENU.MUTE.SELECT = "Sélectionne un joueur que tu veux rendre muet."

LANG.PHEMENU.PLAYER = {}
LANG.PHEMENU.PLAYER.TAB = "Joueur"
LANG.PHEMENU.PLAYER.OPTIONS = "Options du joueur :"

LANG.PHEMENU.PLAYER.ph_cl_halos = "Activer l'effet de halo lors du choix d'un Prop"
LANG.PHEMENU.PLAYER.ph_cl_pltext = "Voir l'équipe du joueur au dessus de la tête (apparaît à travers les murs)"
LANG.PHEMENU.PLAYER.ph_cl_endround_sound = "Jouer la musique à la fin de la manche"
LANG.PHEMENU.PLAYER.ph_cl_autoclose_taunt = "Fermer automatiquement le menu des taunts lors d'un double clic"
LANG.PHEMENU.PLAYER.ph_cl_spec_hunter_line = "Afficher la ligne aim des hunters en spectateur"
LANG.PHEMENU.PLAYER.cl_enable_luckyballs_icon = "Activer les icones 'Lucky ball'"
LANG.PHEMENU.PLAYER.cl_enable_devilballs_icon = "Activer les icones 'Devil ball'"
LANG.PHEMENU.PLAYER.ph_cl_taunt_key = "Bouton pour jouer un taunt aléatoire"

LANG.PHEMENU.PLAYER.ph_hud_use_new = "Utiliser le nouveau HUD"
LANG.PHEMENU.PLAYER.ph_show_tutor_control = "Afficher le tutoriel (Apparaît 2x à chaque apparition en Prop)"
LANG.PHEMENU.PLAYER.ph_show_custom_crosshair = "Activer le viseur customisé"
LANG.PHEMENU.PLAYER.ph_show_team_topbar = "Afficher le nombre total de joueurs de l'équipe en vie (4 joueurs minimum)"

LANG.PHEMENU.PLAYERMODEL = {}
LANG.PHEMENU.PLAYERMODEL.TAB = "Skins"
LANG.PHEMENU.PLAYERMODEL.OFF = "Les skins personnalisés sont désactivés sur le serveur !"
LANG.PHEMENU.PLAYERMODEL.SETFOV = "Définir le FOV des skins"


LANG.PHEMENU.ADMINS = {}
LANG.PHEMENU.ADMINS.TAB = "Administration"

LANG.PHEMENU.ADMINS.OPTIONS = "Options Serveur du mode de jeu (visible uniquement pour les admins)"

LANG.PHEMENU.ADMINS.ph_language = "Langue du mode de jeu (nécessite un changement de map)"
LANG.PHEMENU.ADMINS.ph_use_custom_plmodel = "Activer les modèles personnalisés pour les Hunters"
LANG.PHEMENU.ADMINS.ph_use_custom_plmodel_for_prop = "Activer les modèles personnalisés pour les Props - doit être activé pour les Hunters."
LANG.PHEMENU.ADMINS.ph_customtaunts_delay = "Délai des taunts personnalisés (secondes)"
LANG.PHEMENU.ADMINS.ph_normal_taunt_delay = "Délai des taunts normaux (secondes)"
LANG.PHEMENU.ADMINS.ph_autotaunt_enabled = "Activer l'Autotaunt"
LANG.PHEMENU.ADMINS.ph_autotaunt_delay = "Délai de l'Autotaunt (Secondes)"

LANG.PHEMENU.ADMINS.TAUNTMODES = "Activer les taunts customisés."
LANG.PHEMENU.ADMINS.TAUNTMODE0 = "Mode [0/F3]: Taunt aléatoire"
LANG.PHEMENU.ADMINS.TAUNTMODE1 = "Mode [1/C]: Taunt customisé"
LANG.PHEMENU.ADMINS.TAUNTMODE2 = "Mode [2]: Taunt aléatoire et customisé"
LANG.PHEMENU.ADMINS.TAUNTSOPEN = "Ouvrir le menu des taunts"

LANG.PHEMENU.MAPVOTE = {}

LANG.PHEMENU.MAPVOTE.TAB = "MapVote"
LANG.PHEMENU.MAPVOTE.SETTINGS = "Paramètres MapVote"

LANG.PHEMENU.MAPVOTE.mv_allowcurmap = "Autoriser la map actuelle à être votée"
LANG.PHEMENU.MAPVOTE.mv_cooldown = "Activer le cooldown pour les votes"
LANG.PHEMENU.MAPVOTE.mv_use_ulx_votemaps = "Utiliser le Mapvote ULX pour la liste ? Si non, les maps du dossier maps/*.bsp seront utilisées."
LANG.PHEMENU.MAPVOTE.mv_maplimit = "Nombre de maps à afficher lors du vote."
LANG.PHEMENU.MAPVOTE.mv_timelimit = "Temps en seconde pour le Mapvote."
LANG.PHEMENU.MAPVOTE.mv_mapbeforerevote = "Changement de map requis pour faire réapparaitre cette map"
LANG.PHEMENU.MAPVOTE.mv_rtvcount = "Nombre de joueurs nécessaires pour le RTV (Rock the Vote)"

LANG.PHEMENU.MAPVOTE.EXPLANATION1 = "Pour définir les maps à utiliser, utilisez (par exemple) [ mv_mapprefix 'ph_,cs_,de_' ] dans la console."
LANG.PHEMENU.MAPVOTE.EXPLANATION2 = "Si vous n'arrivez pas à utiliser le Mapvote, il FAUT installer ULX Admin Mod!"
LANG.PHEMENU.MAPVOTE.EXPLANATION3 = "Action MapVote (pour annuler, utilisez !unmap_vote dans le chat ou 'unmap_vote' dans la console)"

LANG.PHEMENU.MAPVOTE.START = "Démarrer un MapVote"
LANG.PHEMENU.MAPVOTE.STOP = "Arrêter un MapVote"
--                   YOU VIOLATED THE LAW!

LANG.PHEMENU.ABOUT = {}

LANG.PHEMENU.ABOUT.CURRENTVER = "Version actuelle : "
LANG.PHEMENU.ABOUT.ENJOYING = "Si vous aimez le jeu, vous pouvez faire un don !"
LANG.PHEMENU.ABOUT.LINKS = "Liens et crédits"
LANG.PHEMENU.ABOUT.THANKS = "Remerciements spéciaux : "
LANG.PHEMENU.ABOUT.TAB = "À propos de PHE"
LANG.PHEMENU.ABOUT.DONATE = "FAIRE UN DON au projet PH:E"
LANG.PHEMENU.ABOUT.HOME = "Page d'accueil officielle de PH:E"
LANG.PHEMENU.ABOUT.GIT = "Dépôt GitHub"
LANG.PHEMENU.ABOUT.WIKI = "Manuels et wiki PH:E"
LANG.PHEMENU.ABOUT.PLUGINS = "Modules complémentaires/plugins PH:E"


LANG.ERROR_ADMIN_ONLY = "Vous devez être administrateur pour effectuer cette action."

LANG.TAUNTWINDOW = {}
LANG.TAUNTWINDOW.ph_cl_tauntpitch = "Pitch/Hauteur (100 = normal)"
LANG.TAUNTWINDOW.ph_cl_pitched_autotaunts = "Utiliser un pitch aléatoire pour les autotaunts"
LANG.TAUNTWINDOW.ph_cl_pitched_randtaunts = "Utiliser un pitch aléatoire pour les taunts random déclenchés manuellement"

LANG.FORCEHUNTERASPROP = {}
LANG.FORCEHUNTERASPROP.WILL_BE = " sera forcément un Prop au prochain tour."
LANG.FORCEHUNTERASPROP.ALREADY = " a déjà été défini comme futur Prop."

LANG.UNSTUCK = {}
LANG.UNSTUCK.YOURE_UNSTUCK = "Vous devriez être décoincé !"
LANG.UNSTUCK.BAD_SPAWNPOINT = "Erreur : Le point de spawn le plus proche pourrait vous coincer à nouveau. Si c'est le cas, essayez encore de vous décoincer."
LANG.UNSTUCK.RESCUE_SPAWNPOINT = "Ce point de spawn est extrêmement proche, vous pourriez encore être coincé. Si c'est le cas, essayez encore de vous décoincer."
LANG.UNSTUCK.NO_SPAWNPOINTS = "Pour des raisons inconnues, aucun point de spawn n'a été trouvé. Comme dernier recours, vous allez être téléporté en (0, 0, 0). Il y a une très grande chance que vous y serez coincé, alors si vous l'êtes, essayez encore de vous décoincer."
LANG.UNSTUCK.PLEASE_WAIT = "Veuillez attendre %d secondes entre chaque tentative de décoinçage."
LANG.UNSTUCK.NOT_ON_GROUND = "Au-dessus du sol : vérification en cours..."
LANG.UNSTUCK.NOT_STUCK_JITTER = "Vous n'êtes pas coincé. Si vous l'êtes vraiment, attendez que votre prop arrête de bouger (essayez d'appuyer sur ALT) puis réessayez."
LANG.UNSTUCK.NOT_STUCK_TOOBAD = "Vous n'êtes pas coincé. Si vous l'êtes vraiment, désolé, il va falloir attendre la fin du tour."
LANG.UNSTUCK.CANNOT_FIND_SPOT = "Impossible de trouver un emplacement correct : téléportation au point de spawn le plus proche."
LANG.UNSTUCK.SPAWNPOINTS_DISABLED = "Vous alliez être téléporté vers un point de spawn proche, mais ce serveur l'interdit en dehors de la période de cache. Désolé."

LANG.PHEMENU.PLAYER.ph_cl_unstuck_key = "Touche pour essayer de se décoincer"

LANG.PHEMENU.ADMINS.ph_tauntpitch_allowed = "Permettre aux joueurs d'utiliser les fonctionnalités liées au pitch (hauteur) des taunts"
LANG.PHEMENU.ADMINS.ph_tauntpitch_min = "Pitch minimal des taunts (60 par défaut)"
LANG.PHEMENU.ADMINS.ph_tauntpitch_max = "Pitch maximal des taunts (180 par défaut)"
LANG.PHEMENU.ADMINS.ph_originalteambalance = "Utiliser l'équilibrage original de PH:E (désactive toutes les options suivantes liées aux équipes)"
LANG.PHEMENU.ADMINS.ph_originalteambalance_warning = "Décochez la case précédente pour accéder aux options avancées d'équilibrage des équipes."
LANG.PHEMENU.ADMINS.ph_forcespectatorstoplay = "Forcer les spectateurs à jouer en les prenant en compte durant l'équilibrage des équipes"
LANG.PHEMENU.ADMINS.ph_preventconsecutivehunting = "Empêcher les joueurs d'être Hunter deux fois de suite (ne fonctionne qu'en mode aléatoire)"
LANG.PHEMENU.ADMINS.ph_huntercount = "Nombre de hunters (0 = automatique)"
LANG.PHEMENU.ADMINS.ph_rotateteams = "Désactiver le mode aléatoire et faire des rotations à la place"
LANG.PHEMENU.ADMINS.ResetRotateTeams_warning = "Recommencer les rotations depuis le début (si tu as commencé les rotations, arrêté, que tu reprends et que la rotation actuelle ne convient pas) :"
LANG.PHEMENU.ADMINS.ResetRotateTeams = "Reset les rotations"
LANG.PHEMENU.ADMINS.ForceHunterAsProp_warning = "Forcer un Hunter à être Prop la prochaine fois (ne fonctionne qu'en mode aléatoire) :"
LANG.PHEMENU.ADMINS.ForceHunterAsProp_randomonly = "Cette action n'est disponible qu'en mode aléatoire."
LANG.PHEMENU.ADMINS.ForceHunterAsProp_nohunters = "[PAS DE HUNTERS]"
LANG.PHEMENU.ADMINS.ForceHunterAsProp_nohuntersmsg = "Mais. Y'a marqué qu'il y a pas de hunters. Faut lire, merde."
LANG.PHEMENU.ADMINS.ph_experimentalpropcollisions = "[EXPÉRIMENTAL] Collisions des props moins strictes (permet parfois de ne pas se bloquer),\nmais donne dans certains cas une petite hitbox à des grands objets (n'affecte pas les tirs d'armes)"
LANG.PHEMENU.ADMINS.ph_disabletpunstuckinround = "Désactiver les téléportations décoinçantes de dernier recours aux points de spawn en dehors de la période de cache"
LANG.PHEMENU.ADMINS.ph_unstuck_waittime = "Délai minimum entre chaque tentative de décoinçage"
LANG.PHEMENU.ADMINS.ph_falldamage = "Activer les dégâts de chute"

LANG.PHEMENU.ABOUT.ENHANCED_BY = "Amélioré par "


-- Saving
PHE.LANGUAGES[LANG.Code] = LANG
