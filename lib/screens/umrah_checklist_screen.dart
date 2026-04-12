import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
class _P{final Color bg,surface,accent,gold,fg,muted,divider;const _P({required this.bg,required this.surface,required this.accent,required this.gold,required this.fg,required this.muted,required this.divider});
  static _P of(bool d)=>d?const _P(bg:Color(0xFF0E1A19),surface:Color(0xFF182624),accent:Color(0xFF4FBFA8),gold:Color(0xFFE3C77B),fg:Color(0xFFF5F1E8),muted:Color(0xFF8B968F),divider:Color(0xFF243532)):const _P(bg:Color(0xFFF8F5EE),surface:Color(0xFFFFFFFF),accent:Color(0xFF2C7A6B),gold:Color(0xFFB8902B),fg:Color(0xFF1F2937),muted:Color(0xFF6B6359),divider:Color(0xFFE8DDD0));}

class UmrahChecklistScreen extends StatefulWidget{const UmrahChecklistScreen({super.key});@override State<UmrahChecklistScreen>createState()=>_UmrahChecklistScreenS();}
class _UmrahChecklistScreenS extends State<UmrahChecklistScreen>{Set<int>_checked={};
  @override void initState(){super.initState();_load();}
  Future<void>_load()async{final p=await SharedPreferences.getInstance();final r=p.getStringList('umrahChecklist_checked');if(r!=null)_checked=r.map((s)=>int.tryParse(s)??-1).where((i)=>i>=0).toSet();if(!mounted)return;setState((){});}
  Future<void>_save()async{final p=await SharedPreferences.getInstance();await p.setStringList('umrahChecklist_checked',_checked.map((e)=>e.toString()).toList());}
  void _toggle(int i){HapticFeedback.lightImpact();setState((){_checked.contains(i)?_checked.remove(i):_checked.add(i);});_save();}
  @override Widget build(BuildContext c){final p=_P.of(Provider.of<AppProvider>(c).isDarkMode);final l=AppLocalizations.of(c)!;
    final items=["uc_1","uc_2","uc_3","uc_4","uc_5","uc_6","uc_7","uc_8"];
    final progress=items.isEmpty?0.0:_checked.length/items.length;
    return Scaffold(backgroundColor:p.bg,appBar:AppBar(backgroundColor:Colors.transparent,elevation:0,scrolledUnderElevation:0,foregroundColor:p.fg,title:Text(l.translate('umrahChecklist'),style:TextStyle(fontSize:15,fontWeight:FontWeight.w500,color:p.muted)),centerTitle:true),
      body:ListView(padding:const EdgeInsets.fromLTRB(20,0,20,32),children:[
        Container(padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:p.gold.withOpacity(0.08),borderRadius:BorderRadius.circular(12)),
          child:Row(children:[Text('${_checked.length}/${items.length}',style:TextStyle(fontSize:16,fontWeight:FontWeight.w700,color:p.gold)),const SizedBox(width:12),
            Expanded(child:ClipRRect(borderRadius:BorderRadius.circular(3),child:LinearProgressIndicator(value:progress,minHeight:6,backgroundColor:p.divider,valueColor:AlwaysStoppedAnimation(p.gold))))])),
        const SizedBox(height:16),
        ...List.generate(items.length,(i){final done=_checked.contains(i);return GestureDetector(onTap:()=>_toggle(i),child:AnimatedContainer(duration:const Duration(milliseconds:200),margin:const EdgeInsets.only(bottom:8),padding:const EdgeInsets.all(14),
          decoration:BoxDecoration(color:done?p.gold.withOpacity(0.06):p.surface,borderRadius:BorderRadius.circular(12),border:Border.all(color:done?p.gold.withOpacity(0.3):p.divider)),
          child:Row(children:[AnimatedContainer(duration:const Duration(milliseconds:200),width:24,height:24,decoration:BoxDecoration(shape:BoxShape.circle,color:done?p.gold:Colors.transparent,border:Border.all(color:done?p.gold:p.divider,width:1.5)),
            child:done?const Icon(Icons.check,size:14,color:Colors.white):null),const SizedBox(width:10),
            Expanded(child:Text(l.translate(items[i]),style:TextStyle(fontSize:13,color:done?p.muted:p.fg,height:1.4,decoration:done?TextDecoration.lineThrough:null,decorationColor:p.muted.withOpacity(0.3))))])));
        }),
      ]));}}
