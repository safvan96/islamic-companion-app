import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
class _P{final Color bg,surface,accent,gold,fg,muted,divider;const _P({required this.bg,required this.surface,required this.accent,required this.gold,required this.fg,required this.muted,required this.divider});
  static _P of(bool d)=>d?const _P(bg:Color(0xFF0E1A19),surface:Color(0xFF182624),accent:Color(0xFF4FBFA8),gold:Color(0xFFE3C77B),fg:Color(0xFFF5F1E8),muted:Color(0xFF8B968F),divider:Color(0xFF243532)):const _P(bg:Color(0xFFF8F5EE),surface:Color(0xFFFFFFFF),accent:Color(0xFF2C7A6B),gold:Color(0xFFB8902B),fg:Color(0xFF1F2937),muted:Color(0xFF6B6359),divider:Color(0xFFE8DDD0));}
class IslamicDreamScreen extends StatelessWidget{const IslamicDreamScreen({super.key});
  @override Widget build(BuildContext c){final p=_P.of(Provider.of<AppProvider>(c).isDarkMode);final l=AppLocalizations.of(c)!;
    return Scaffold(backgroundColor:p.bg,appBar:AppBar(backgroundColor:Colors.transparent,elevation:0,scrolledUnderElevation:0,foregroundColor:p.fg,title:Text(l.translate('islamicDream'),style:TextStyle(fontSize:15,fontWeight:FontWeight.w500,color:p.muted)),centerTitle:true),
      body:ListView(padding:const EdgeInsets.fromLTRB(20,0,20,32),children:[
        Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:p.gold.withOpacity(0.08),borderRadius:BorderRadius.circular(14),border:Border.all(color:p.gold.withOpacity(0.2))),
          child:Text(l.translate('islamicDreamInfo'),style:TextStyle(fontSize:13,color:p.muted,height:1.5))),
      ]));}}
