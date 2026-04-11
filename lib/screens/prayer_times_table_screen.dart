import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
class _P{final Color bg,surface,accent,gold,fg,muted,divider;const _P({required this.bg,required this.surface,required this.accent,required this.gold,required this.fg,required this.muted,required this.divider});
  static _P of(bool d)=>d?const _P(bg:Color(0xFF0E1A19),surface:Color(0xFF182624),accent:Color(0xFF4FBFA8),gold:Color(0xFFE3C77B),fg:Color(0xFFF5F1E8),muted:Color(0xFF8B968F),divider:Color(0xFF243532)):const _P(bg:Color(0xFFF8F5EE),surface:Color(0xFFFFFFFF),accent:Color(0xFF2C7A6B),gold:Color(0xFFB8902B),fg:Color(0xFF1F2937),muted:Color(0xFF6B6359),divider:Color(0xFFE8DDD0));}

const _prayers=[('fajr',Icons.wb_twilight,'pt_fajr',Color(0xFF7E57C2)),('dhuhr',Icons.wb_sunny,'pt_dhuhr',Color(0xFFFFB300)),('asr',Icons.sunny_snowing,'pt_asr',Color(0xFFFF8F00)),('maghrib',Icons.nights_stay_outlined,'pt_maghrib',Color(0xFFE53935)),('isha',Icons.dark_mode_outlined,'pt_isha',Color(0xFF1565C0))];
class PrayerTimesTableScreen extends StatelessWidget{const PrayerTimesTableScreen({super.key});
  @override Widget build(BuildContext c){final p=_P.of(Provider.of<AppProvider>(c).isDarkMode);final l=AppLocalizations.of(c)!;
    return Scaffold(backgroundColor:p.bg,appBar:AppBar(backgroundColor:Colors.transparent,elevation:0,scrolledUnderElevation:0,foregroundColor:p.fg,title:Text(l.translate('prayerTimesTable'),style:TextStyle(fontSize:15,fontWeight:FontWeight.w500,color:p.muted)),centerTitle:true),
      body:ListView(padding:const EdgeInsets.fromLTRB(20,0,20,32),children:[
        Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:p.gold.withOpacity(0.08),borderRadius:BorderRadius.circular(14)),
          child:Text(l.translate('ptInfo'),textAlign:TextAlign.center,style:TextStyle(fontSize:12,color:p.muted,height:1.4))),
        const SizedBox(height:16),
        ..._prayers.map((pr){final(nameKey,icon,descKey,color)=pr;return Container(margin:const EdgeInsets.only(bottom:10),padding:const EdgeInsets.all(16),
          decoration:BoxDecoration(color:p.surface,borderRadius:BorderRadius.circular(14),border:Border.all(color:p.divider)),
          child:Row(children:[Container(width:44,height:44,decoration:BoxDecoration(shape:BoxShape.circle,color:color.withOpacity(0.12)),child:Icon(icon,size:22,color:color)),const SizedBox(width:14),
            Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(l.translate(nameKey),style:TextStyle(fontSize:16,fontWeight:FontWeight.w600,color:p.fg)),Text(l.translate(descKey),style:TextStyle(fontSize:12,color:p.muted))]))]));
        }),
      ]));}}
