name 'windows-gaming'

default_source :community

run_list(
         'chocolatey',
         'pantry'
        )

default['chocolatey']['packages'] = %W(google-chrome-x64 git emacs sysinternals
                                       putty conemu dropbox curl wget winscp githubforwindows
                                       steam battle.net leagueoflegends mumble teamspeak
                                       )
