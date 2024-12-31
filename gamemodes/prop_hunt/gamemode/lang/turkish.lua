local LANG = {}

-- Language code and name
LANG.Code = "tr"
LANG.Name = "türkçe"
LANG.NameEnglish = "turkish"

LANG.Help = [[	Gelişmiş Klasik Nesne Avı Oyun Modu.
Daha Fazla Yardım Görmek İçin 'Nesne Avı Menüsü'ne tıklayın!

	Sürüm: %s
		Değişiklikler:
		- Takım dengesi iyileştirildi
		- Sıkışmaktan kurtulma tuşu
		- Özelletirebilir alay sesi
		- ve daha fazlası!
	]]

-- HUD elements
LANG.HUD = {}

LANG.HUD.HEALTH = "SAĞLIK"
LANG.HUD.AMMO = "CEPHANE"
LANG.HUD.TIME = "SÜRE"
LANG.HUD.ROUND = "RAUNT"

LANG.HUD.ROTLOCKON = "Nesne Döndürme: Kilitli"
LANG.HUD.ROTLOCKOFF = "Nesne Döndürme: Serbest"
LANG.HUD.FREEZECAM = "%s tarafından öldürüldün"

LANG.HUD.WAIT = "Oyuncular bekleniyor..."
LANG.HUD.WIN = "%s kazandı!"
LANG.HUD.DRAW = "Berabere, herkes kaybetti!"

LANG.HUD.BLINDTIME = "Avcıların gözleri %s içinde açılacak ve serbest kalacaklar"
LANG.HUD.BLINDEND = "Önüm arkam sağım solum sobe saklanmayan ebe!"

--  Kill text (X killed Y)
LANG.DEATHNOTICE = {}
LANG.DEATHNOTICE.KILLED = "şu oyuncuyu öldürdü:"

LANG.DEATHNOTICE.SUICIDE = {
	"intihar etti!",
	"esrarengiz bir şekilde öldü.",
	"büyüden öldü.",
	"boşuna öldü.",
	"istemeden öldü.",
	"komik bir şekilde öldü.",
	"öldü.",
	"panikleyip öldü.",
	"kendini dürbünsüz öldürdü.",
	"tansiyonu düştü.",
	"kendinden geçti.",
	"öldü. Bir dahakine iyi şanslar!",
	"kendini tokatladı.",
	"ayağı kayıp düştü.",
	"kendine hâkim olamadı.",
	"duvara kafa attı.",
	"baskıdan öldü.",
	"öldü. Ltfn F'ye basın.",
	"masum nesneleri öldürdükten sonra pişmanlık duyuyor.",
	"yere yapıştı.",
	"soyunu kurutmayı deniyor.",
	"çok fena öldü.",
	"acayip bir şekilde öldü.",
	"değişik bir şekilde öldü.",
	"gizemli bir şekilde öldü.",
	"çarpıldı.",
	"kalp krizi geçirdi.",
	"bütün nesneleri öldürecekken panikledi.",
	"dur artık, yardıma ihtiyacın var.",
	"paçavra oldu.",
}

-- Common
LANG.MISC = {}

LANG.MISC.ACCEPT = "Kabul"
LANG.MISC.CLOSE = "Kapat"
LANG.MISC.TIMELEFT = "Kalan Süre: %s"
LANG.MISC.NOTIMELEFT = "Oyun bu raunttan sonra bitecektir"

-- Derma elements
LANG.DERMA = {}

-- Team selection screen (F2)
LANG.DERMA.TEAMSELECT = "Takım Seç"

-- F1 screeen
LANG.DERMA.RTV = "Harita Değişmek İçin Oyla (RTV)"
LANG.DERMA.PHMENU = "Nesne Avı Menüsü"
LANG.DERMA.CHANGETEAM = "Takım Değiş"

-- Scoreboard
LANG.DERMA.PLAYER = "(%d oyuncu)"
LANG.DERMA.PLAYERS = "(%d oyuncu)"
LANG.DERMA.NAME = "Ad"
LANG.DERMA.KILLS = "Leş"
LANG.DERMA.DEATHS = "Ölüm"
LANG.DERMA.PING = "Gecikme"

-- Chat messages
LANG.CHAT = {}

LANG.CHAT.NOTENOUGHPLYS = "Oyunu başlatmak için yeterli oyuncu yok!"
LANG.CHAT.SWAP = "Takımlar değiştirildi!"

LANG.CHAT.JOINED = " şu takıma katıldı: "
LANG.CHAT.JOINEDTHE = " şu takıma katıldı: "

LANG.CHAT.SWAPBALANCE = "Takım dengesi için %s, %s takımına aktarıldı."
LANG.CHAT.SWAPBALANCEYOU = "Mükemmel dengeyi sağlamak için aktarıldın." -- Smile... for even in death, you have become children of Thanos

LANG.CHAT.RANDOM_SPECTATORS = {
	"takımına oturup izlemek için geçti.",
	"takımına takılmalarını izlemek için geçti.",
	"takımına ne olup bittiğini izlemek için geçti.",
	"",
}

-- PHE Menu (F1 > PHE Menu)
LANG.PHEMENU = {}


LANG.PHEMENU.HELP = {}
LANG.PHEMENU.HELP.TAB = "Yardım"

LANG.PHEMENU.MUTE = {}
LANG.PHEMENU.MUTE.TAB = "Sustur"
LANG.PHEMENU.MUTE.SELECT = "Susturmak istediğiniz oyuncuyu seçin."

LANG.PHEMENU.PLAYER = {}
LANG.PHEMENU.PLAYER.TAB = "Oyuncu"
LANG.PHEMENU.PLAYER.OPTIONS = "Oyuncu Ayarları:"

LANG.PHEMENU.PLAYER.ph_cl_halos = "Nesne seçerken parlama efektini etkinleştir"
LANG.PHEMENU.PLAYER.ph_cl_pltext = "Takım oyuncularının adlarını başlarının üstünde göster (ayrıca duvar arkası gözükür)"
LANG.PHEMENU.PLAYER.ph_cl_endround_sound = "Raunt sonu işareti sesini çal"
LANG.PHEMENU.PLAYER.ph_cl_autoclose_taunt = "Çift tıklandığında alay penceresini otomatik kapatma seçeneği"
LANG.PHEMENU.PLAYER.ph_cl_spec_hunter_line = "İzleyici modunda avcıların nereye nişan aldığını görmek için ışın çizer."
LANG.PHEMENU.PLAYER.cl_enable_luckyballs_icon = "'Şanslı top' düştüğünde simgesini görünür yap"
LANG.PHEMENU.PLAYER.cl_enable_devilballs_icon = "'Şeytan top' düştüğünde simgesini görünür yap"
LANG.PHEMENU.PLAYER.ph_cl_taunt_key = "Rastgele alay tuşu"

LANG.PHEMENU.PLAYER.ph_hud_use_new = "Yeni Gelişmiş Arayüzü Kullan (PH: Enhanced HUD)"
LANG.PHEMENU.PLAYER.ph_show_tutor_control = "Öğretici Pencereyi Göster (2 kere nesne takımında doğunca gösterir)"
LANG.PHEMENU.PLAYER.ph_show_custom_crosshair = "Özel Nişangahı Etkinleştir"
LANG.PHEMENU.PLAYER.ph_show_team_topbar = "Toplam hayatta olan takım oyuncularını sol üst köşede gösterir (En az 4 oyuncu gösterilir)"

LANG.PHEMENU.PLAYERMODEL = {}
LANG.PHEMENU.PLAYERMODEL.TAB = "Oyuncu Modelleri"
LANG.PHEMENU.PLAYERMODEL.OFF = "Üzgünüz, Özel Oyuncu Modelleri bu sunucuda devre dışı!"
LANG.PHEMENU.PLAYERMODEL.SETFOV = "Model Görüş Açısını Ayarla"


LANG.PHEMENU.ADMINS = {}
LANG.PHEMENU.ADMINS.TAB = "Yönetici"

LANG.PHEMENU.ADMINS.OPTIONS = "Sunucunun oyun ayarları (Sadece Yöneticilere ve Kurucuya Görünür)"

LANG.PHEMENU.ADMINS.ph_language = "Oyun Modu Dili (harita değişikliği gerektirir)"
LANG.PHEMENU.ADMINS.ph_use_custom_plmodel = "Avcılar için özel modelleri etkinleştir"
LANG.PHEMENU.ADMINS.ph_use_custom_plmodel_for_prop = "Nesneler için özel modelleri etkinleştir - Avcılar için de etkinleştirdiğinizden emin olun."
LANG.PHEMENU.ADMINS.ph_customtaunts_delay = "Özel Alay Gecikmesi (Saniye)"
LANG.PHEMENU.ADMINS.ph_normal_taunt_delay = "Normal Alay Gecikmesi (Saniye)"
LANG.PHEMENU.ADMINS.ph_autotaunt_enabled = "Otomatik Alay Özelliklerini Etkinleştir"
LANG.PHEMENU.ADMINS.ph_autotaunt_delay = "Otomatik Alay Gecikmesi (Saniye)"
LANG.PHEMENU.ADMINS.ph_forcejoinbalancedteams = "Oyuncular katıldıklarında takımları eşitlemesini sağla"
LANG.PHEMENU.ADMINS.ph_autoteambalance = "Raunt başında otomatik olarak takımları eşitle"
LANG.PHEMENU.ADMINS.ph_allow_prop_pickup = "Küçük nesnelerle etkileşime izin ver (0 = Hayır; 1 = Evet; 2 = Sadece Avcılar)"

LANG.PHEMENU.ADMINS.ph_notice_prop_rotation = "Her doğulduğunda 'Nesne Dönme' bildirimini göster"
LANG.PHEMENU.ADMINS.ph_prop_camera_collisions = "Nesne kamerasının duvarlara değmesini etkinleştir"
LANG.PHEMENU.ADMINS.ph_freezecam = "Nesne takımı için Serbest Kamera özelliğini etkinleştir"
LANG.PHEMENU.ADMINS.ph_prop_collision = "Nesne takımındaki oyuncuların birbirine değebilmesini etkinleştir."
LANG.PHEMENU.ADMINS.ph_swap_teams_every_round = "Her raunt takım değiştir - Bu ayar devre dışı bırakılırsa takımlar olduğu gibi kalacaktır."
LANG.PHEMENU.ADMINS.ph_hunter_fire_penalty = "Avcı can cezası"
LANG.PHEMENU.ADMINS.ph_hunter_kill_bonus = "Avcı leş bonusu"
LANG.PHEMENU.ADMINS.ph_hunter_smg_grenades = "Avcı HMS bombaları"
LANG.PHEMENU.ADMINS.ph_game_time = "Toplam Oyun Süresi (Dakika)"
LANG.PHEMENU.ADMINS.ph_hunter_blindlock_time = "Avcı yumma süresi (Saniye)"
LANG.PHEMENU.ADMINS.ph_round_time = "Oyun raunt süresi (Saniye)"
LANG.PHEMENU.ADMINS.ph_rounds_per_map = "Harita Başı Toplam Oyun Raundu"
LANG.PHEMENU.ADMINS.ph_enable_lucky_balls = "Şanslı Topların kırılabilir nesnelerde çıkmasına izin ver (Çıkma şansı %8)"
LANG.PHEMENU.ADMINS.ph_enable_devil_balls = "Şeytan Toplarının avcı öldüğünde çıkmasına izin ver (Çıkma şansı 70%)"
LANG.PHEMENU.ADMINS.ph_waitforplayers = "Oyuna başlamak için oyuncuları bekle"
LANG.PHEMENU.ADMINS.ph_min_waitforplayers = "Oyunun başlaması için gereken en az oyuncu sayısı (varsayılan: 1)"

LANG.PHEMENU.ADMINS.TAUNTMODES = "Enable Custom Taunt."
LANG.PHEMENU.ADMINS.TAUNTMODE0 = "Mod [0/F3]: Rastgele Alay"
LANG.PHEMENU.ADMINS.TAUNTMODE1 = "Mod [1/C]: Özel Alay"
LANG.PHEMENU.ADMINS.TAUNTMODE2 = "Mod [2]: Her İkiside"
LANG.PHEMENU.ADMINS.TAUNTSOPEN = "Alay Penceresini Aç"

LANG.PHEMENU.MAPVOTE = {}

LANG.PHEMENU.MAPVOTE.TAB = "Harita Oylama"
LANG.PHEMENU.MAPVOTE.SETTINGS = "Harita Oylama Ayarları"

LANG.PHEMENU.MAPVOTE.mv_allowcurmap = "Mevcut haritanın oylanmasına izin ver"
LANG.PHEMENU.MAPVOTE.mv_cooldown = "Oylama için harita bekleme süresini etkinleştir"
LANG.PHEMENU.MAPVOTE.mv_use_ulx_votemaps = "ULX harita oylama listesini kullan? Eğer yoksa, varsayılan maps/*.bsp kullanılacak."
LANG.PHEMENU.MAPVOTE.mv_maplimit = "Harita oylamasından gösterilen haritaların sayısı."
LANG.PHEMENU.MAPVOTE.mv_timelimit = "Varsayılan harita oylama süresi (Saniye)."
LANG.PHEMENU.MAPVOTE.mv_mapbeforerevote = "Bir haritanın yeniden gözükmesi için gereken harita değişikliği sayısı"
LANG.PHEMENU.MAPVOTE.mv_rtvcount = "Oylamayı başlatmak için gerekli oyuncu sayısı (RTV)"

LANG.PHEMENU.MAPVOTE.EXPLANATION1 = "Hangi haritanın listeleneceği, Örneğin [ mv_mapprefix 'ph_,cs_,de_' ] konsolda kullanın."
LANG.PHEMENU.MAPVOTE.EXPLANATION2 = "Eğer harita oylaması yapamıyorsanız ULX Admin Mod'unu kurmanız gerekiyor!"
LANG.PHEMENU.MAPVOTE.EXPLANATION3 = "Harita Oylama Eylemi (İptal etmek için, basitçe sohbette !unmap_vote yazın veya konsola 'unmap_vote' yazın)"

LANG.PHEMENU.MAPVOTE.START = "Harita Oylamasını Başlat"
LANG.PHEMENU.MAPVOTE.STOP = "Harita Oylamasını Durdur"
--                   YOU VIOLATED THE LAW!

LANG.PHEMENU.ABOUT = {}

LANG.PHEMENU.ABOUT.CURRENTVER = "Güncel Sürüm: "
LANG.PHEMENU.ABOUT.ENJOYING = "Eğer oyunda eğleniyorsanız, bağış yapmaya ne dersiniz!"
LANG.PHEMENU.ABOUT.LINKS = "Bağlantılar ve Emeği Geçenler"
LANG.PHEMENU.ABOUT.THANKS = "Özel teşekkürler: "
LANG.PHEMENU.ABOUT.TAB = "PHE Hakkında"
LANG.PHEMENU.ABOUT.DONATE = "PH:E projesine bağış yap"
LANG.PHEMENU.ABOUT.HOME = "PH:E Resmi Ana Sayfası"
LANG.PHEMENU.ABOUT.GIT = "GitHub Dizini"
LANG.PHEMENU.ABOUT.WIKI = "PH:E Viki & Rehber"
LANG.PHEMENU.ABOUT.PLUGINS = "PH:E Eklentiler"


LANG.ERROR_ADMIN_ONLY = "Bunu yapabilmeniz için bir yönetici olmanız gerekiyor."

LANG.TAUNTWINDOW = {}
LANG.TAUNTWINDOW.ph_cl_tauntpitch = "Perdeleme (100 = normal)"
LANG.TAUNTWINDOW.ph_cl_pitched_autotaunts = "Otomatik alay ederken ses perdeleme seviyesini rastgele seç"
LANG.TAUNTWINDOW.ph_cl_pitched_randtaunts = "Rastgele alaylar için ses perdelemesi kullan"

LANG.FORCEHUNTERASPROP = {}
LANG.FORCEHUNTERASPROP.WILL_BE = " sonraki raunt Nesne olacak."
LANG.FORCEHUNTERASPROP.ALREADY = " zaten bir sonraki raunt için Nesne olarak belirlenmiş."

LANG.UNSTUCK = {}
LANG.UNSTUCK.YOURE_UNSTUCK = "Artık kurtulmuş olmalısın!"
LANG.UNSTUCK.BAD_SPAWNPOINT = "Hata: En yakın doğma noktası seni yeniden sıkıştırabilir. Eğer sıkışırsan, yeniden kurtulmayı deneyin."
LANG.UNSTUCK.RESCUE_SPAWNPOINT = "Bu doğma noktası aşırı yakın, hala sıkışmış olabilirsin. Sıkışmışsanız yeniden deneyin."
LANG.UNSTUCK.NO_SPAWNPOINTS = "Bilinmeyen nedenlerden ötürü, doğma noktası bulunamadı. Önlem olarak, (0, 0, 0)a ışınlanacaksanız. Sıkışmanıza çok yüksek bir şans var, eğer sıkışırsanız tekrar deneyin."
LANG.UNSTUCK.PLEASE_WAIT = "Lütfen her bir sıkışmaktan kurtulma denemesinde %d saniye bekleyin."
LANG.UNSTUCK.NOT_ON_GROUND = "Zeminde değil, kontrol ediliyor..."
LANG.UNSTUCK.NOT_STUCK_JITTER = "Sıkışmamışsınız. Eğer gerçekten sıkıştıysanız, Nesneniniz hareket etmeyi veya titremeyi bırakana kadar bekleyin (ALT'a basmayı deneyin) ve yeniden deneyin."
LANG.UNSTUCK.NOT_STUCK_TOOBAD = "Sıkışmamışsınız. Eğer gerçekten sıkıştıysanız, üzgünüm, raunt sonuna kadar beklemek zorundasın.."
LANG.UNSTUCK.CANNOT_FIND_SPOT = "Sizin hareket edebileceğiniz bir yer bulunamadı, en yakın doğma noktasına ışınlanılıyor."
LANG.UNSTUCK.SPAWNPOINTS_DISABLED = "Doğma noktasına ışınlanacaktın, ama bu sunucu yumma süresinin dışında izin vermiyor. Üzgünüz!"

LANG.PHEMENU.PLAYER.ph_cl_unstuck_key = "Sıkışmaktan Kurtulma Tuşu"

LANG.PHEMENU.ADMINS.ph_tauntpitch_allowed = "Oyuncuların alay perdeleme işlevini kullanmasına izin ver"
LANG.PHEMENU.ADMINS.ph_tauntpitch_min = "Minimum alay perdelemesi (varsayılan değer 60)"
LANG.PHEMENU.ADMINS.ph_tauntpitch_max = "Maksimum alay perdelemesi (varsayılan değer 180)"
LANG.PHEMENU.ADMINS.ph_originalteambalance = "PH:E'nin kendi takım dengeleme özelliğini kullan (takım ilgili aşağıdaki tüm ayarları devre dışı bırakır)"
LANG.PHEMENU.ADMINS.ph_originalteambalance_uncheck = "Gelişmiş takım dengesi ayarlarına erişmek için önceki onay kutusunun işaretini kaldırın.."
LANG.PHEMENU.ADMINS.ph_forcespectatorstoplay = "Takımları dengelerken izleyicileri oynaması için zorla"
LANG.PHEMENU.ADMINS.ph_preventconsecutivehunting = "Oyuncuların arka arkaya iki kez Avcı olmasını engelle (Sadece karma modunda çalışır)"
LANG.PHEMENU.ADMINS.ph_huntercount = "Avcı sayısı (0 = otomatik)"
LANG.PHEMENU.ADMINS.ph_rotateteams = "Karma modu devre dışı bırak ve oyuncuları aktarmayı kullan"
LANG.PHEMENU.ADMINS.ResetRotateTeams_warning = "Başlangıçta değişmeyi yeniden başlat (eğer onları başlatmışsan, veya durdurmuşsan, ve yeniden başlatmışsanız ve şu anki değişim sizi memnun etmiyorsa):"
LANG.PHEMENU.ADMINS.ResetRotateTeams = "Aktarmaları sıfırla"
LANG.PHEMENU.ADMINS.ForceHunterAsProp_warning = "Bir Avcıyı bir dahaki sefere Nesne olması için zorla (sadece karma modunda çalışır):"
LANG.PHEMENU.ADMINS.ForceHunterAsProp_randomonly = "Bu eylem sadece karma modunda geçerli."
LANG.PHEMENU.ADMINS.ForceHunterAsProp_nohunters = "[AVCI YOK]"
LANG.PHEMENU.ADMINS.ForceHunterAsProp_nohuntersmsg = "Avcı yok Allah kahretsin, düğmede yazılı görmüyor musun?"
LANG.PHEMENU.ADMINS.ph_experimentalpropcollisions = "[DENEYSEL] daha rahat nesne çarpışması (sıkışmayı engelleyebilir), ama bazen büyük nesnelere küçük hitbox verir (mermileri etkilemez)"
LANG.PHEMENU.ADMINS.ph_disabletpunstuckinround = "Saklanma aşamasındayken doğma noktalarının dışında son çare olarak sıkışmaktan kurtulmak için ışınlanmayı devre dışı bırak"
LANG.PHEMENU.ADMINS.ph_unstuck_waittime = "Her bir sıkışmaktan kurtulma denemesi arasında kaç saniye geçmeli"
LANG.PHEMENU.ADMINS.ph_falldamage = "Düşme hasarını etkinleştir"

LANG.PHEMENU.ABOUT.ENHANCED_BY = "(Enhanced) Gelişmiş Sürüm: "


-- Saving
PHE.LANGUAGES[LANG.Code] = LANG
