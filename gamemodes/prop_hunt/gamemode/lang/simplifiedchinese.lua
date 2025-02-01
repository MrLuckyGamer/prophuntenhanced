local LANG = {}

-- Language code and name
LANG.Code = "cn"
LANG.Name = "简体中文"
LANG.NameEnglish = "SimplifiedChinese"

LANG.Help = [[	一个增强版的Prop Hunt模式，
点击'Prop Hunt Menu'来获得帮助!

	游戏模式版本: %s
		本次更新:
		- 改进过的团队平衡
		- 修复按钮卡顿
		- 可自定义的嘲讽声音
		- 还有更多!
	]]

-- HUD elements
LANG.HUD = {}

LANG.HUD.HEALTH = "血量"
LANG.HUD.AMMO = "弹药"
LANG.HUD.TIME = "时间"
LANG.HUD.ROUND = "回合"

LANG.HUD.ROTLOCKON = "Prop旋转状态:已锁定"
LANG.HUD.ROTLOCKOFF = "Prop旋转状态:自由移动"
LANG.HUD.FREEZECAM = "你被 %s 击杀了"

LANG.HUD.WAIT = "正在等待玩家..."
LANG.HUD.WIN = "%s 胜利!"
LANG.HUD.DRAW = "平局, 所有人都是输家!"

LANG.HUD.BLINDTIME = "距离猎人开始狩猎还剩下 %s 秒"
LANG.HUD.BLINDEND = "不管准没准备好，我们来了！"

--  Kill text (X killed Y)
LANG.DEATHNOTICE = {}
LANG.DEATHNOTICE.KILLED = "已被击杀！"

LANG.DEATHNOTICE.SUICIDE = {
	"自杀了!",
	"离奇死亡了.",
	"被魔法杀死了.",
	"瞎打死掉了.",
	"气急败坏退游了.",
	"喝酒溜大了.",
	"死亡...祝下次好运!",
	"扇死了自己",
	"被棍子绊倒了.",
	"被原力杀死了.",
	"变成了布娃娃.",
}

-- Common
LANG.MISC = {}

LANG.MISC.ACCEPT = "接受"
LANG.MISC.CLOSE = "关闭"
LANG.MISC.TIMELEFT = "剩余时间: %s"
LANG.MISC.NOTIMELEFT = "本回合之后游戏将会结束"

-- Derma elements
LANG.DERMA = {}

-- Team selection screen (F2)
LANG.DERMA.TEAMSELECT = "选择团队"

-- F1 screeen
LANG.DERMA.RTV = "滚动投票（换图）"
LANG.DERMA.PHMENU = "Prop Hunt 菜单"
LANG.DERMA.CHANGETEAM = "更改队伍"

-- Scoreboard
LANG.DERMA.PLAYER = "(%d 名玩家)"
LANG.DERMA.PLAYERS = "(%d 名玩家)"
LANG.DERMA.NAME = "名字"
LANG.DERMA.KILLS = "击杀"
LANG.DERMA.DEATHS = "死亡"
LANG.DERMA.PING = "Ping"

-- Chat messages
LANG.CHAT = {}

LANG.CHAT.NOTENOUGHPLYS = "没有足够的玩家开始游戏!"
LANG.CHAT.SWAP = "队伍已经切换!"

LANG.CHAT.JOINED = " 加入了 "
LANG.CHAT.JOINEDTHE = " 加入了 "

LANG.CHAT.SWAPBALANCE = "%s 已经被转换到 %s 为了团队平衡."
LANG.CHAT.SWAPBALANCEYOU = "为了完美平衡，您的阵营已被切换." -- Smile... for even in death, you have become children of Thanos

LANG.CHAT.RANDOM_SPECTATORS = {
	"边休息边观看吧.",
	"看看他们到处逛吧.",
	"看看周围.",
	"",
}

-- PHE Menu (F1 > PHE Menu)
LANG.PHEMENU = {}


LANG.PHEMENU.HELP = {}
LANG.PHEMENU.HELP.TAB = "帮助"

LANG.PHEMENU.MUTE = {}
LANG.PHEMENU.MUTE.TAB = "静音"
LANG.PHEMENU.MUTE.SELECT = "选择一个你想要静音的玩家."

LANG.PHEMENU.PLAYER = {}
LANG.PHEMENU.PLAYER.TAB = "玩家"
LANG.PHEMENU.PLAYER.OPTIONS = "玩家设置:"

LANG.PHEMENU.PLAYER.ph_cl_halos = "切换选择一个物品时的周围光效"
LANG.PHEMENU.PLAYER.ph_cl_pltext = "将玩家名字显示在他们的头顶上 (字会穿过墙壁)"
LANG.PHEMENU.PLAYER.ph_cl_endround_sound = "播放回合结束提示音"
LANG.PHEMENU.PLAYER.ph_cl_autoclose_taunt = "双击嘲讽窗口时自动关闭"
LANG.PHEMENU.PLAYER.ph_cl_spec_hunter_line = "在猎人身上画一条线，这样我们就可以在旁观者模式中看到他们的瞄准方向."
LANG.PHEMENU.PLAYER.cl_enable_luckyballs_icon = "启用“幸运球”图标，以便在它们生成后显示"
LANG.PHEMENU.PLAYER.cl_enable_devilballs_icon = "启用“恶魔球”图标，以便在它们生成后显示"
LANG.PHEMENU.PLAYER.ph_cl_taunt_key = "随机播放嘲讽按钮"

LANG.PHEMENU.PLAYER.ph_hud_use_new = "使用Prop Hunt模式更好的hud"
LANG.PHEMENU.PLAYER.ph_show_tutor_control = "显示教程弹出窗口 (每个道具生成时只显示 2 次)"
LANG.PHEMENU.PLAYER.ph_show_custom_crosshair = "启用自定义准心"
LANG.PHEMENU.PLAYER.ph_show_team_topbar = "在左上角显示存活的团队玩家总数栏 (至少会显示四个玩家)"

LANG.PHEMENU.PLAYERMODEL = {}
LANG.PHEMENU.PLAYERMODEL.TAB = "玩家模型"
LANG.PHEMENU.PLAYERMODEL.OFF = "抱歉，自定义玩家模型在这个服务器上被禁用了!"
LANG.PHEMENU.PLAYERMODEL.SETFOV = "设置模型广角"


LANG.PHEMENU.ADMINS = {}
LANG.PHEMENU.ADMINS.TAB = "管理员"

LANG.PHEMENU.ADMINS.OPTIONS = "服务端的游戏模式选项 (只有服主或管理员能看到)"

LANG.PHEMENU.ADMINS.ph_language = "游戏模式语言 (需要换图)"
LANG.PHEMENU.ADMINS.ph_use_custom_plmodel = "允许猎人使用自定义模型"
LANG.PHEMENU.ADMINS.ph_use_custom_plmodel_for_prop = "为物品启用自定义模型 - 确保也为猎人们启用."
LANG.PHEMENU.ADMINS.ph_customtaunts_delay = "自定义嘲讽间隔 (秒)"
LANG.PHEMENU.ADMINS.ph_normal_taunt_delay = "普通嘲讽间隔 (秒)"
LANG.PHEMENU.ADMINS.ph_autotaunt_enabled = "启用自动嘲讽功能"
LANG.PHEMENU.ADMINS.ph_autotaunt_delay = "自动嘲讽间隔 (秒)"
LANG.PHEMENU.ADMINS.ph_forcejoinbalancedteams = "迫使加入的玩家自动平衡队伍"
LANG.PHEMENU.ADMINS.ph_autoteambalance = "在对局开始时自动平衡队伍"
LANG.PHEMENU.ADMINS.ph_allow_prop_pickup = "允许捡起小物品 (0 = 不允许; 1 = 允许; 2 = 只允许猎人)"

LANG.PHEMENU.ADMINS.ph_notice_prop_rotation = "在每个 Prop 生成时显示 '物品旋转' 通知"
LANG.PHEMENU.ADMINS.ph_prop_camera_collisions = "允许物品的相机穿过墙壁"
LANG.PHEMENU.ADMINS.ph_freezecam = "为同队的道具启用相机自由移动功能"
LANG.PHEMENU.ADMINS.ph_prop_collision = "启用假扮成物品的玩家之间碰撞"
LANG.PHEMENU.ADMINS.ph_swap_teams_every_round = "每回合开始时转换队伍 - 禁用此选项意味着队伍将永不切换"
LANG.PHEMENU.ADMINS.ph_hunter_fire_penalty = "猎人生命值惩罚"
LANG.PHEMENU.ADMINS.ph_hunter_kill_bonus = "猎人击杀奖励"
LANG.PHEMENU.ADMINS.ph_hunter_smg_grenades = "猎人Smg榴弹"
LANG.PHEMENU.ADMINS.ph_game_time = "游戏总时长(分钟)"
LANG.PHEMENU.ADMINS.ph_hunter_blindlock_time = "猎人盲目时间 (秒)"
LANG.PHEMENU.ADMINS.ph_round_time = "游戏回合时间 (秒)"
LANG.PHEMENU.ADMINS.ph_rounds_per_map = "每个地图的总局数"
LANG.PHEMENU.ADMINS.ph_enable_lucky_balls = "允许在易碎的道具上生成幸运球 (8%概率)"
LANG.PHEMENU.ADMINS.ph_enable_devil_balls = "允许在猎人死亡时生成恶魔球 (70%概率)"
LANG.PHEMENU.ADMINS.ph_waitforplayers = "在游戏开始前等待玩家加入"
LANG.PHEMENU.ADMINS.ph_min_waitforplayers = "游戏开始前所需要等待的最小玩家数 (默认为1)"

LANG.PHEMENU.ADMINS.TAUNTMODES = "启用自定义嘲讽."
LANG.PHEMENU.ADMINS.TAUNTMODE0 = "模式 [0/F3]: 随机嘲讽"
LANG.PHEMENU.ADMINS.TAUNTMODE1 = "模式 [1/C]: 自定义嘲讽"
LANG.PHEMENU.ADMINS.TAUNTMODE2 = "模式 [2]: 两种嘲讽皆有"
LANG.PHEMENU.ADMINS.TAUNTSOPEN = "打开嘲讽窗口"

LANG.PHEMENU.MAPVOTE = {}

LANG.PHEMENU.MAPVOTE.TAB = "地图投票"
LANG.PHEMENU.MAPVOTE.SETTINGS = "地图投票设置"

LANG.PHEMENU.MAPVOTE.mv_allowcurmap = "允许对当前地图进行投票"
LANG.PHEMENU.MAPVOTE.mv_cooldown = "启用地图冷却期间投票"
LANG.PHEMENU.MAPVOTE.mv_use_ulx_votemaps = "是否使用 ULX Mapvote 中的地图列表? 如果不使用，将使用默认maps/*.bsp."
LANG.PHEMENU.MAPVOTE.mv_maplimit = "在 MapVote 中显示的地图数量."
LANG.PHEMENU.MAPVOTE.mv_timelimit = "投票时默认地图投票的持续秒数."
LANG.PHEMENU.MAPVOTE.mv_mapbeforerevote = "地图重新出现所需的变更次数"
LANG.PHEMENU.MAPVOTE.mv_rtvcount = "使用滚动投票所需的玩家人数)"

LANG.PHEMENU.MAPVOTE.EXPLANATION1 = "要设置哪些地图应该被列出，请在控制台中使用（例如）[ mv_mapprefix 'ph_,cs_,de_' ]."
LANG.PHEMENU.MAPVOTE.EXPLANATION2 = "如果你无法进行地图投票，你需要安装ULX管理插件!"
LANG.PHEMENU.MAPVOTE.EXPLANATION3 = "地图投票操作（如要取消，只需在聊天中输入 !unmap_vote 或在控制台中输入 'unmap_vote'）"

LANG.PHEMENU.MAPVOTE.START = "开始地图投票"
LANG.PHEMENU.MAPVOTE.STOP = "停止地图投票"
--                   YOU VIOLATED THE LAW!

LANG.PHEMENU.ABOUT = {}

LANG.PHEMENU.ABOUT.CURRENTVER = "当前版本: "
LANG.PHEMENU.ABOUT.ENJOYING = "如果你喜欢这款游戏，请考虑捐赠!"
LANG.PHEMENU.ABOUT.LINKS = "链接和致谢"
LANG.PHEMENU.ABOUT.THANKS = "特别感谢: "
LANG.PHEMENU.ABOUT.TAB = "关于 PHE"
LANG.PHEMENU.ABOUT.DONATE = "向 Wolvindra 捐赠"
LANG.PHEMENU.ABOUT.HOME = "PH:E 官方主页"


LANG.ERROR_ADMIN_ONLY = "您必须是管理员才能执行此操作."


LANG.TAUNTWINDOW = {}
LANG.TAUNTWINDOW.ph_cl_tauntpitch = "音量 (100 = 正常)"
LANG.TAUNTWINDOW.ph_cl_pitched_autotaunts = "自动嘲讽使用随机音量"
LANG.TAUNTWINDOW.ph_cl_pitched_randtaunts = "为手动触发的随机嘲讽使用随机音量"

LANG.FORCEHUNTERASPROP = {}
LANG.FORCEHUNTERASPROP.WILL_BE = " 下回合要变成Prop."
LANG.FORCEHUNTERASPROP.ALREADY = " 已经确定下回合要成为Prop."

LANG.UNSTUCK = {}
LANG.UNSTUCK.YOURE_UNSTUCK = "你应该不会卡住了!"
LANG.UNSTUCK.BAD_SPAWNPOINT = "错误: 最近的重生点可能会让你再次卡住. 如果你卡住了, 尝试再一次解决卡住."
LANG.UNSTUCK.RESCUE_SPAWNPOINT = "这个重生点太近了, 所以你可能还会被卡住. 如果你被卡住了请尝试再一次解决卡住."
LANG.UNSTUCK.NO_SPAWNPOINTS = "由于位置的错误, 无法找到重生点. 因此, 你会被传送到(0, 0, 0). 你很可能会再次被卡住, 所以如果你被卡住了请再一次尝试解决卡住."
LANG.UNSTUCK.PLEASE_WAIT = "请在 %d 秒后再尝试解决卡住."
LANG.UNSTUCK.NOT_ON_GROUND = "没有落地，再次检查..."
LANG.UNSTUCK.NOT_STUCK_JITTER = "你没有卡住. 如果你卡住了, 等到你的prop不再移动/抖动(尝试按ALT)后再重新尝试."
LANG.UNSTUCK.NOT_STUCK_TOOBAD = "你没有卡住. 如果你卡住了, 你只能等到回合结束了."
LANG.UNSTUCK.CANNOT_FIND_SPOT = "找不到地方安置你, 正在将你传送到最近的出生点."
LANG.UNSTUCK.SPAWNPOINTS_DISABLED = "你本来将会被传送到最近的出生点, 但是服务器不允许在躲藏时间以外这样做."

LANG.PHEMENU.PLAYER.ph_cl_unstuck_key = "按此解除卡住"

LANG.PHEMENU.ADMINS.ph_tauntpitch_allowed = "允许玩家使用嘲讽功能"
LANG.PHEMENU.ADMINS.ph_tauntpitch_min = "最小嘲讽音量（默认值为 60）"
LANG.PHEMENU.ADMINS.ph_tauntpitch_max = "最小嘲讽音量（默认值为 60）"
LANG.PHEMENU.ADMINS.ph_originalteambalance = "使用 PH:E 的原始团队平衡（禁用以下所有团队相关选项）"
LANG.PHEMENU.ADMINS.ph_originalteambalance_uncheck = "取消上一个复选框以访问高级团队平衡选项."
LANG.PHEMENU.ADMINS.ph_forcespectatorstoplay = "强制观众参与游戏（在平衡团队时强制使其加入）"
LANG.PHEMENU.ADMINS.ph_preventconsecutivehunting = "防止玩家连续两次成为猎人（仅在随机模式下有效）"
LANG.PHEMENU.ADMINS.ph_huntercount = "猎人数量（0 = 自动）"
LANG.PHEMENU.ADMINS.ph_rotateteams = "禁用随机模式，改为轮换玩家"
LANG.PHEMENU.ADMINS.ResetRotateTeams_warning = "从头开始轮换（如果你已经开始了轮换，然后停止，再重新开始，而当前轮换不符合你的要求）:"
LANG.PHEMENU.ADMINS.ResetRotateTeams = "重置轮换"
LANG.PHEMENU.ADMINS.ForceHunterAsProp_warning = "强制猎人下一次成为物品（仅在随机模式下有效）:"
LANG.PHEMENU.ADMINS.ForceHunterAsProp_randomonly = "此操作仅在随机模式下有效."
LANG.PHEMENU.ADMINS.ForceHunterAsProp_nohunters = "[无猎人]"
LANG.PHEMENU.ADMINS.ForceHunterAsProp_nohuntersmsg = "没有猎人，按钮上已经写得很清楚了."
LANG.PHEMENU.ADMINS.ph_experimentalpropcollisions = "[实验性] 更宽松的道具碰撞（可能防止卡住），但有时会给大型道具一个小碰撞盒（不影响子弹)"
LANG.PHEMENU.ADMINS.ph_disabletpunstuckinround = "在躲藏阶段之外禁用最后手段的解困传送"
LANG.PHEMENU.ADMINS.ph_unstuck_waittime = "每次解困尝试之间必须等待的秒数"
LANG.PHEMENU.ADMINS.ph_falldamage = "启用坠落伤害"

LANG.PHEMENU.ABOUT.ENHANCED_BY = "增强版由 "


-- Saving
PHE.LANGUAGES[LANG.Code] = LANG
