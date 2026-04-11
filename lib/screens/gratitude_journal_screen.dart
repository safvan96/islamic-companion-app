import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
class _P{final Color bg,surface,accent,gold,fg,muted,divider;const _P({required this.bg,required this.surface,required this.accent,required this.gold,required this.fg,required this.muted,required this.divider});
  static _P of(bool d)=>d?const _P(bg:Color(0xFF0E1A19),surface:Color(0xFF182624),accent:Color(0xFF4FBFA8),gold:Color(0xFFE3C77B),fg:Color(0xFFF5F1E8),muted:Color(0xFF8B968F),divider:Color(0xFF243532)):const _P(bg:Color(0xFFF8F5EE),surface:Color(0xFFFFFFFF),accent:Color(0xFF2C7A6B),gold:Color(0xFFB8902B),fg:Color(0xFF1F2937),muted:Color(0xFF6B6359),divider:Color(0xFFE8DDD0));}

class GratitudeJournalScreen extends StatefulWidget{const GratitudeJournalScreen({super.key});@override State<GratitudeJournalScreen>createState()=>_GJS();}
class _GJS extends State<GratitudeJournalScreen>{List<String>_items=[];final _ctrl=TextEditingController();
  @override void initState(){super.initState();_load();}
  Future<void>_load()async{final p=await SharedPreferences.getInstance();final r=p.getStringList('gratitude');if(r!=null)_items=r;setState((){});}
  Future<void>_save()async{final p=await SharedPreferences.getInstance();await p.setStringList('gratitude',_items);}
  void _add(){if(_ctrl.text.trim().isEmpty)return;HapticFeedback.lightImpact();setState((){_items.insert(0,_ctrl.text.trim());_ctrl.clear();});_save();}
  @override Widget build(BuildContext c){final p=_P.of(Provider.of<AppProvider>(c).isDarkMode);final l=AppLocalizations.of(c)!;
    return Scaffold(backgroundColor:p.bg,appBar:AppBar(backgroundColor:Colors.transparent,elevation:0,scrolledUnderElevation:0,foregroundColor:p.fg,title:Text(l.translate('gratitudeJournal'),style:TextStyle(fontSize:15,fontWeight:FontWeight.w500,color:p.muted)),centerTitle:true),
      body:Column(children:[
        Padding(padding:const EdgeInsets.fromLTRB(20,0,20,8),child:Container(padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:p.gold.withOpacity(0.08),borderRadius:BorderRadius.circular(12)),
          child:Text(l.translate('gratitudeJournalInfo'),style:TextStyle(fontSize:12,color:p.muted,height:1.4)))),
        Padding(padding:const EdgeInsets.symmetric(horizontal:20),child:Row(children:[
          Expanded(child:Container(decoration:BoxDecoration(color:p.surface,borderRadius:BorderRadius.circular(12),border:Border.all(color:p.divider)),
            child:TextField(controller:_ctrl,style:TextStyle(color:p.fg,fontSize:14),decoration:InputDecoration(hintText:'I am grateful for...',hintStyle:TextStyle(color:p.muted),border:InputBorder.none,contentPadding:const EdgeInsets.symmetric(horizontal:14,vertical:12))))),
          const SizedBox(width:8),
          GestureDetector(onTap:_add,child:Container(width:44,height:44,decoration:BoxDecoration(color:p.gold,borderRadius:BorderRadius.circular(12)),child:const Icon(Icons.add,color:Colors.white)))])),
        const SizedBox(height:12),
        Expanded(child:_items.isEmpty?Center(child:Text(l.translate('gratitudeJournalInfo'),style:TextStyle(color:p.muted))):ListView.builder(padding:const EdgeInsets.fromLTRB(20,0,20,32),itemCount:_items.length,itemBuilder:(_,i)=>Container(margin:const EdgeInsets.only(bottom:8),padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:p.surface,borderRadius:BorderRadius.circular(12),border:Border.all(color:p.divider)),
          child:Row(children:[Icon(Icons.favorite,size:16,color:p.gold),const SizedBox(width:10),Expanded(child:Text(_items[i],style:TextStyle(fontSize:13,color:p.fg,height:1.4)))])))),
      ]));}}
