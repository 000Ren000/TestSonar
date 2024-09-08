﻿Процедура СохранитьПризнакЗакрытияБаннера(ИмяБаннера) Экспорт
	
	ХранилищеОбщихНастроек.Сохранить("ЗакрытыеБаннерыЭПД", ИмяБаннера, Истина);	
	
КонецПроцедуры

Функция ПолучитьПризнакЗакрытияБаннера(ИмяБаннера) Экспорт
	
	Возврат ХранилищеОбщихНастроек.Загрузить("ЗакрытыеБаннерыЭПД", ИмяБаннера);	
	
КонецФункции

Функция ЗначенияРеквизитовОбъекта(Объект, Реквизиты) Экспорт
	
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект, Реквизиты);
	
КонецФункции

Функция НазваниеИВерсияПрограммы() Экспорт
	
	Возврат ОбменСГИСЭПД.НазваниеИВерсияПрограммы();
	
КонецФункции

Функция ДанныеСертификатаУчетнойЗаписиЭДО(ИдентификаторУчетнойЗаписи, ОтборПодписанта = Неопределено) Экспорт
	
	Возврат ОбменСГИСЭПД.ДанныеСертификатаУчетнойЗаписиЭДО(ИдентификаторУчетнойЗаписи, ОтборПодписанта);
	
КонецФункции

Функция ПолучитьПрокси(Схема) Экспорт
	
	Возврат ПолучениеФайловИзИнтернета.ПолучитьПрокси(Схема);
	
КонецФункции

Функция ЗаписатьОшибкуВЖурнал(ИмяСобытия, ИнформацияОбОшибке) Экспорт
	
	Возврат ОбменСГИСЭПД.ЗаписатьОшибкуВЖурнал(ИмяСобытия, ИнформацияОбОшибке);
	
КонецФункции

Функция СведенияОбАдресе(РезультатЗначение, ДополнительныеПараметры) Экспорт
	
	Возврат РаботаСАдресами.СведенияОбАдресе(РезультатЗначение, ДополнительныеПараметры);
	
КонецФункции

Функция КонтактнаяИнформацияВXML(ЗначенияПолей, Представление = "", ОжидаемыйВид = Неопределено) Экспорт
	
	Возврат ОбменСГИСЭПД.КонтактнаяИнформацияВXML(ЗначенияПолей, 
													Представление,
													ОжидаемыйВид);
	
КонецФункции


Функция ПредставлениеКонтактнойИнформации(КонтактнаяИнформация) Экспорт
	
	Возврат ОбменСГИСЭПД.ПредставлениеКонтактнойИнформации(КонтактнаяИнформация);
	
КонецФункции

Функция ПолучитьРеквизитыУчастника(Участник, ДобавитьПлатежныеРеквизиты = Ложь) Экспорт
	
	Возврат ОбменСГИСЭПД.ПолучитьРеквизитыУчастника(Участник, ДобавитьПлатежныеРеквизиты);
	
КонецФункции

Функция ПолучитьРеквизитыФизЛица(ФизЛицо, Организация = Неопределено) Экспорт
	
	Возврат ОбменСГИСЭПД.ПолучитьРеквизитыФизЛица(ФизЛицо, Организация);
	
КонецФункции

Функция НайтиЭлектронныйДокументОбъектаУчета(ОбъектУчета) Экспорт
	
	Возврат ОбменСГИСЭПД.НайтиЭлектронныйДокументОбъектаУчета(ОбъектУчета);
	
КонецФункции

Функция ДвоичныеДанныеДокументаЭПД(Объект, АдресВоВременномХранилище) Экспорт
	
	Возврат ОбменСГИСЭПД.ДвоичныеДанныеДокументаЭПД(Объект,, АдресВоВременномХранилище);
	
КонецФункции


Функция ПолучитьТипОрганизация() Экспорт
	
	Возврат ОбменСГИСЭПДСерверПовтИсп.ПолучитьТипОрганизация();	
	
КонецФункции

Функция ПолучитьТипКонтрагент() Экспорт
	
	Возврат ОбменСГИСЭПДСерверПовтИсп.ПолучитьТипКонтрагент();	
	
КонецФункции

Функция ПолучитьИдентификаторЧерезСервисОператораЭДО(ИдентификаторАбонента, ЭтоВторойТитул = Ложь, ДокументСсылка = Неопределено) Экспорт
	
	Возврат ОбменСГИСЭПД.ПолучитьИдентификаторЧерезСервисОператораЭДО(ИдентификаторАбонента, ЭтоВторойТитул, ДокументСсылка);
	
КонецФункции

Функция ПолучитьОписаниеОшибки(ОбъектСсылка) Экспорт
	
	Возврат ОбменСГИСЭПД.ПолучитьОписаниеОшибки(ОбъектСсылка);
	
КонецФункции

Функция ПолучитьСообщениеТитула(Документ, ТипЭлементаРегламента, ВернутьЭД = Ложь) Экспорт
	
	Возврат ОбменСГИСЭПД.ПолучитьСообщениеТитула(Документ, ТипЭлементаРегламента, ВернутьЭД);
	
КонецФункции

Функция СостояниеДокументаПодробное(ЭлектронныйДокумент) Экспорт
	
	Возврат ЭлектронныеДокументыЭДО.СостояниеДокументаПодробное(ЭлектронныйДокумент);
	
КонецФункции

Функция ПолучитьТитулыПоДокументу(Документ, ТолькоЗавершенныеОтправки = Ложь) Экспорт

	Возврат ОбменСГИСЭПД.ПолучитьТитулыПоДокументу(Документ, ТолькоЗавершенныеОтправки);

КонецФункции

Функция ПолучитьВерсииТитуловДокумента(Знач Документ, Знач Организация) Экспорт

	Возврат ОбменСГИСЭПД.ПолучитьВерсииТитуловДокумента(Документ, Организация);

КонецФункции

Функция ПолучитьАдресаДоставки(ЗначениеОтбора) Экспорт
	
	Возврат ОбменСГИСЭПД.ПолучитьАдресаДоставки(ЗначениеОтбора);
	
КонецФункции

Процедура ОтметитьИсправлениеДокумента(ОбъектУчета) Экспорт
	
	ОбменСГИСЭПД.ОтметитьИсправлениеДокумента(ОбъектУчета);
	
КонецПроцедуры

Функция ВидФактическийАдресКонтрагента() Экспорт

	Возврат ОбменСГИСЭПДПереопределяемый.ВидФактическийАдресКонтрагента();
	
КонецФункции

Функция ИмяТипаБанковскиеСчетаОрганизации() Экспорт
	
	Возврат ОбменСГИСЭПДПереопределяемый.ИмяТипаБанковскиеСчетаОрганизации();
	
КонецФункции

Функция ЭтоУОУ(ТипЭлементаРегламента) Экспорт
	
	Возврат ОбменСГИСЭПД.ЭтоУОУ(ТипЭлементаРегламента);
	
КонецФункции

// Возвращает полное имя основной формы объекта.
//
// Параметры:
//  Ссылка	 - 	ЛюбаяСсылка - ссылка на объект. Например, ДокументСсылка или СправочникСсылка.
// 
// Возвращаемое значение:
//  Строка - полное имя основной формы объекта.
//
Функция ПолноеИмяФормыОбъекта(Ссылка) Экспорт
	
	ИмяФормы = "";
	ОбъектМетаданных = Ссылка.Метаданные();
	
	Если ОбщегоНазначения.ЭтоДокумент(ОбъектМетаданных) Тогда
		ИмяФормы = ОбъектМетаданных.ПолноеИмя() + ".ФормаОбъекта";
	ИначеЕсли ОбщегоНазначения.ЭтоСправочник(ОбъектМетаданных) Тогда
		ИмяФормы = ОбъектМетаданных.Формы.ФормаЭлемента.ПолноеИмя();
	КонецЕсли;
		
	Возврат ИмяФормы;
	
КонецФункции

Процедура УстановитьПометкуУдаления(Ссылка) Экспорт
	
	Объект = Ссылка.ПолучитьОбъект();
	Объект.УстановитьПометкуУдаления(НЕ Объект.ПометкаУдаления);
	
КонецПроцедуры

Функция ПолучитьУИДМинтранса(КлючСинхронизации, ЭтоВторойТитул = Ложь, ДокументСсылка = Неопределено) Экспорт
	
	ПараметрыВызова = СервисЭДО.НовыеПараметрыВыполненияОперацииСервиса(КлючСинхронизации);
	
	Если КлючСинхронизации = Неопределено Тогда
		Возврат "";	
	КонецЕсли;
	
	ПараметрыВызова.АдресРесурса = "epd/v1/GetUID/" + КлючСинхронизации.ИдентификаторУчетнойЗаписи;
	ПараметрыВызова.Метод = "GET";
	Если ЭтоВторойТитул = Истина И ДокументСсылка <> Неопределено Тогда
		ЭД = ИнтеграцияЭДО.ОсновнойЭлектронныйДокументОбъектаУчета(ДокументСсылка);
		Если ЗначениеЗаполнено(ЭД) Тогда
			ПерваяТранзакция = Неопределено;
			Если ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ЭлектроннаяТранспортнаяНакладная") Тогда
				ПерваяТранзакция = "ShipperInformation";	
			ИначеЕсли ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ЭлектронныйЗаказНаряд") Тогда
				ПерваяТранзакция = "ChartererInformation";
			ИначеЕсли ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ЭлектронныйЗаказЗаявка") Тогда
				ПерваяТранзакция = "SendOrder";	
			ИначеЕсли ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ЭлектронныйПутевойЛист") Тогда
				ПерваяТранзакция = "OwnerVehicleInfo";
			ИначеЕсли ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ЭлектронныйДоговорФрахтования") Тогда
				ПерваяТранзакция = "SendOrder";	
			КонецЕсли;
			ПараметрыВызова.АдресРесурса = ПараметрыВызова.АдресРесурса + "?docflow_id=" + ЭД.ИдентификаторДокументооборота;
			Если ПерваяТранзакция <> Неопределено Тогда	
				ПараметрыВызова.АдресРесурса = ПараметрыВызова.АдресРесурса + "&transaction=" + ПерваяТранзакция;
			КонецЕсли;
		КонецЕсли;	
	КонецЕсли;
	
	КонтекстДиагностики = ОбработкаНеисправностейБЭД.НовыйКонтекстДиагностики();
	РезультатВыполненияОперации = СервисЭДО.ВыполнитьОперацию(ПараметрыВызова, КонтекстДиагностики, КлючСинхронизации);
	
	Если РезультатВыполненияОперации.Успех = Истина Тогда
		Возврат РезультатВыполненияОперации.Ответ.ПолучитьТелоКакСтроку();
	Иначе
		Возврат "";
	КонецЕсли;
					
КонецФункции

Функция ПолучитьПочтуВодителей(МассивВодители, ИмяРеквизита = "Почта") Экспорт
	
	Возврат ОбменСГИСЭПД.ПолучитьПочтуВодителей(МассивВодители, ИмяРеквизита);
	
КонецФункции

Функция ДанныеРеквизитовЭПД(Документ, Титул = Неопределено, ВсеВерсии = Ложь) Экспорт
	
	Возврат ОбменСГИСЭПД.ДанныеРеквизитовЭПД(Документ, Титул, ВсеВерсии);
		
КонецФункции

Функция ПоискДокументовПоСтроке(Поиск, ОтборТипыДокументов = Неопределено, ПоляПоиска = Неопределено, Период = Неопределено) Экспорт
	
	Возврат ОбменСГИСЭПД.ПоискДокументовПоСтроке(Поиск, ОтборТипыДокументов, ПоляПоиска, Период);
	
КонецФункции

#Область ХранимыеДанные

Функция ЗаписатьХранимыеДанныеЭПД(ГруппаДанных, Организация, Контрагент, ДополнительныйОтбор, ОписаниеДанных) Экспорт
										
	Возврат ОбменСГИСЭПД.ЗаписатьХранимыеДанныеЭПД(ГруппаДанных, Организация, Контрагент, ДополнительныйОтбор, ОписаниеДанных);
										
КонецФункции

Функция ПолучитьОписаниеХранимыхДанныхЭПДПоСсылке(ХранимыеДанныеЭПДСсылка, ГруппаДанных, ИдентификаторСтроки = Неопределено) Экспорт
	
	Возврат ОбменСГИСЭПД.ПолучитьОписаниеХранимыхДанныхЭПДПоСсылке(ХранимыеДанныеЭПДСсылка, ГруппаДанных, ИдентификаторСтроки);
	
КонецФункции

Процедура АвтоПодборХранимыхДанныхЭПД(СтрокаПоиска, ДанныеВыбора, Отбор) Экспорт
	
	ОбменСГИСЭПД.АвтоПодборХранимыхДанныхЭПД(СтрокаПоиска, ДанныеВыбора, Отбор);
	
КонецПроцедуры

Функция ПроверитьЗаполнениеДокументаЭПД(ДанныеДляПроверки, ТекущийТитул, ВидДокумента) Экспорт
	
	Возврат ОбменСГИСЭПД.ПроверитьЗаполнениеДокументаЭПД(ДанныеДляПроверки, ТекущийТитул, ВидДокумента)
	
КонецФункции

Функция НастройкиОтправки(КлючНастроекОтправки) Экспорт
	
	Возврат НастройкиОтправкиЭДО.НастройкиОтправки(КлючНастроекОтправки);
	
КонецФункции

#КонецОбласти