import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
class _P{final Color bg,surface,accent,gold,fg,muted,divider;const _P({required this.bg,required this.surface,required this.accent,required this.gold,required this.fg,required this.muted,required this.divider});
  static _P of(bool d)=>d?const _P(bg:Color(0xFF0E1A19),surface:Color(0xFF182624),accent:Color(0xFF4FBFA8),gold:Color(0xFFE3C77B),fg:Color(0xFFF5F1E8),muted:Color(0xFF8B968F),divider:Color(0xFF243532)):const _P(bg:Color(0xFFF8F5EE),surface:Color(0xFFFFFFFF),accent:Color(0xFF2C7A6B),gold:Color(0xFFB8902B),fg:Color(0xFF1F2937),muted:Color(0xFF6B6359),divider:Color(0xFFE8DDD0));}

const _dua='\u0627\u0644\u0644\u0647\u0645 \u0627\u0631\u062d\u0645\u0646\u064a \u0628\u0627\u0644\u0642\u0631\u0622\u0646 \u0648\u0627\u062c\u0639\u0644\u0647 \u0644\u064a \u0625\u0645\u0627\u0645\u0627 \u0648\u0646\u0648\u0631\u0627 \u0648\u0647\u062f\u0649 \u0648\u0631\u062d\u0645\u0629 \u0627\u0644\u0644\u0647\u0645 \u0630\u0643\u0631\u0646\u064a \u0645\u0646\u0647 \u0645\u0627 \u0646\u0633\u064a\u062a \u0648\u0639\u0644\u0645\u0646\u064a \u0645\u0646\u0647 \u0645\u0627 \u062c\u0647\u0644\u062a \u0648\u0627\u0631\u0632\u0642\u0646\u064a \u062a\u0644\u0627\u0648\u062a\u0647 \u0622\u0646\u0627\u0621 \u0627\u0644\u0644\u064a\u0644 \u0648\u0623\u0637\u0631\u0627\u0641 \u0627\u0644\u0646\u0647\u0627\u0631';
class KhatmDuaScreen extends StatelessWidget{const KhatmDuaScreen({super.key});
  @override Widget build(BuildContext context){final p=_P.of(Provider.of<AppProvider>(context).isDarkMode);final l=AppLocalizations.of(context)!;
    return Scaffold(backgroundColor:p.bg,appBar:AppBar(backgroundColor:Colors.transparent,elevation:0,scrolledUnderElevation:0,foregroundColor:p.fg,title:Text(l.translate('khatmDua'),style:TextStyle(fontSize:15,fontWeight:FontWeight.w500,color:p.muted)),centerTitle:true),
      body:ListView(padding:const EdgeInsets.fromLTRB(20,0,20,32),children:[
        Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:p.gold.withOpacity(0.08),borderRadius:BorderRadius.circular(14)),
          child:Text(l.translate('khatmDuaInfo'),style:TextStyle(fontSize:12,color:p.muted,height:1.5))),
        const SizedBox(height:20),
        Container(padding:const EdgeInsets.all(24),decoration:BoxDecoration(color:p.surface,borderRadius:BorderRadius.circular(20),border:Border.all(color:p.gold.withOpacity(0.3))),
          child:Column(children:[Text(_dua,textDirection:TextDirection.rtl,textAlign:TextAlign.center,style:TextStyle(fontSize:20,color:p.fg,height:1.9)),
            const SizedBox(height:16),Container(width:40,height:2,color:p.gold),const SizedBox(height:16),
            Text(l.translate('khatmDuaTrans'),textAlign:TextAlign.center,style:TextStyle(fontSize:13,color:p.muted,fontStyle:FontStyle.italic,height:1.5)),
            const SizedBox(height:12),Row(mainAxisAlignment:MainAxisAlignment.center,children:[
              IconButton(onPressed:(){Clipboard.setData(const ClipboardData(text:_dua));ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.translate('copied')),duration:const Duration(seconds:1)));},icon:Icon(Icons.copy,size:18,color:p.muted)),
              IconButton(onPressed:()=>Share.share('\n\nIslamic Companion App'),icon:Icon(Icons.share_outlined,size:18,color:p.muted))])])),
      ]));}}
