import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
class _P{final Color bg,surface,accent,gold,fg,muted,divider;const _P({required this.bg,required this.surface,required this.accent,required this.gold,required this.fg,required this.muted,required this.divider});
  static _P of(bool d)=>d?const _P(bg:Color(0xFF0E1A19),surface:Color(0xFF182624),accent:Color(0xFF4FBFA8),gold:Color(0xFFE3C77B),fg:Color(0xFFF5F1E8),muted:Color(0xFF8B968F),divider:Color(0xFF243532)):const _P(bg:Color(0xFFF8F5EE),surface:Color(0xFFFFFFFF),accent:Color(0xFF2C7A6B),gold:Color(0xFFB8902B),fg:Color(0xFF1F2937),muted:Color(0xFF6B6359),divider:Color(0xFFE8DDD0));}
class DailySadaqahScreen extends StatefulWidget{const DailySadaqahScreen({super.key});@override State<DailySadaqahScreen>createState()=>_S();}
class _S extends State<DailySadaqahScreen>{int _streak=0;bool _donatedToday=false;
  @override void initState(){super.initState();_load();}
  String _key(DateTime d)=>'${d.year}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')}';
  Future<void> _load()async{final p=await SharedPreferences.getInstance();final today=_key(DateTime.now());_donatedToday=p.getBool('sadaqah_$today')??false;
    _streak=0;for(int i=0;i<365;i++){final d=DateTime.now().subtract(Duration(days:i));if(i==0&&_donatedToday){_streak++;continue;}if(i==0)continue;if(p.getBool('sadaqah_${_key(d)}')??false){_streak++;}else{break;}}if(!mounted)return;setState((){});}
  Future<void> _donate()async{HapticFeedback.mediumImpact();final p=await SharedPreferences.getInstance();await p.setBool('sadaqah_${_key(DateTime.now())}',true);await _load();}
  @override Widget build(BuildContext c){final isDark=Provider.of<AppProvider>(c).isDarkMode;final p=_P.of(isDark);final l=AppLocalizations.of(c)!;
    return Scaffold(backgroundColor:p.bg,appBar:AppBar(backgroundColor:Colors.transparent,elevation:0,scrolledUnderElevation:0,foregroundColor:p.fg,title:Text(l.translate('dailySadaqah'),style:TextStyle(fontSize:15,fontWeight:FontWeight.w500,color:p.muted)),centerTitle:true),
      body:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
        const Spacer(flex:2),
        Text('$_streak',style:TextStyle(fontSize:72,fontWeight:FontWeight.w200,color:p.gold)),
        Text(l.translate('dayStreak'),style:TextStyle(fontSize:14,color:p.muted)),
        const SizedBox(height:32),
        GestureDetector(onTap:_donatedToday?null:_donate,child:AnimatedContainer(duration:const Duration(milliseconds:300),width:140,height:140,decoration:BoxDecoration(shape:BoxShape.circle,color:_donatedToday?p.gold.withOpacity(0.15):p.gold,border:Border.all(color:p.gold,width:3),boxShadow:_donatedToday?[]:[BoxShadow(color:p.gold.withOpacity(0.3),blurRadius:20)]),
          child:Icon(_donatedToday?Icons.check:Icons.volunteer_activism,size:52,color:_donatedToday?p.gold:Colors.white))),
        const SizedBox(height:16),
        Text(_donatedToday?l.translate('sadaqahDone'):l.translate('tapToDonate'),style:TextStyle(fontSize:14,color:_donatedToday?p.gold:p.muted,fontWeight:FontWeight.w600)),
        const Spacer(flex:1),
        Padding(padding:const EdgeInsets.symmetric(horizontal:40),child:Text(l.translate('sadaqahHadith'),textAlign:TextAlign.center,style:TextStyle(fontSize:12,color:p.muted,fontStyle:FontStyle.italic,height:1.5))),
        const SizedBox(height:30),
      ]));
  }
}
