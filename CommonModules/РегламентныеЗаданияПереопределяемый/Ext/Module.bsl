﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет следующие свойств регламентных заданий:
//  - зависимость от функциональных опций;
//  - возможность выполнения в различных режимах работы программы;
//  - прочие параметры.
//
// Параметры:
//  Настройки - ТаблицаЗначений:
//    * РегламентноеЗадание - ОбъектМетаданныхРегламентноеЗадание - регламентное задание.
//    * ФункциональнаяОпция - ОбъектМетаданныхФункциональнаяОпция - функциональная опция,
//        от которой зависит регламентное задание.
//    * ЗависимостьПоИ      - Булево - если регламентное задание зависит более чем
//        от одной функциональной опции и его необходимо включать только тогда,
//        когда все функциональные опции включены, то следует указывать Истина
//        для каждой зависимости.
//        По умолчанию Ложь - если хотя бы одна функциональная опция включена,
//        то регламентное задание тоже включено.
//    * ВключатьПриВключенииФункциональнойОпции - Булево
//                                              - Неопределено - если Ложь, то при
//        включении функциональной опции регламентное задание не будет включаться. Значение
//        Неопределено соответствует значению Истина.
//        По умолчанию - Неопределено.
//    * ДоступноВПодчиненномУзлеРИБ - Булево
//                                  - Неопределено - Истина или Неопределено, если регламентное
//        задание доступно в РИБ.
//        По умолчанию - Неопределено.
//    * ДоступноВАвтономномРабочемМесте - Булево
//                                      - Неопределено - Истина или Неопределено, если регламентное
//        задание доступно в автономном рабочем месте.
//        По умолчанию - Неопределено.
//    * ДоступноВМоделиСервиса - Булево
//                             - Неопределено - Ложь, если необходимо блокировать выполнение регламентного
//        задания (в т.ч. задания очереди) в информационной базе с включенным использованием разделителя.
//        Значение Неопределено трактуется как Истина.
//        По умолчанию - Неопределено.
//    * РаботаетСВнешнимиРесурсами  - Булево - Истина, если регламентное задание модифицирует данные
//        во внешних источниках (получение почты, синхронизация данных и т.п.). Не следует устанавливать
//        значение Истина для регламентных заданий, не модифицирующих данные во внешних источниках.
//        Например, регламентное задание ЗагрузкаКурсовВалют. Регламентные задания, работающие с внешними ресурсами,
//        автоматически отключаются в копии информационной базы. По умолчанию - Ложь.
//    * Параметризуется             - Булево - Истина, если регламентное задание параметризованное.
//        По умолчанию - Ложь.
//
// Пример:
//	Настройка = Настройки.Добавить();
//	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОбновлениеСтатусовДоставкиSMS;
//	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьПочтовыйКлиент;
//	Настройка.ДоступноВМоделиСервиса = Ложь;
//
Процедура ПриОпределенииНастроекРегламентныхЗаданий(Настройки) Экспорт
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	// Конец ИнтеграцияС1СДокументооборотом
	
	РегламентныеЗаданияЛокализация.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.АрхивированиеЧековККМ;
	Настройка.РаботаетСВнешнимиРесурсами = Ложь;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьРозничныеПродажи;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.УдалениеОтложенныхЧековККМ;
	Настройка.РаботаетСВнешнимиРесурсами = Ложь;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьРозничныеПродажи;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.УдалениеЧековККМ;
	Настройка.РаботаетСВнешнимиРесурсами = Ложь;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьРозничныеПродажи;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОбновлениеДанныхОДоступностиТоваровДляВнешнихПользователей;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ВедетсяРаботаЧерезТорговыхПредставителей;
	Настройка.ДоступноВМоделиСервиса = Ложь;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.АктуализацияПотребностейПоГраницеОбеспечения;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьЗаказыХотяБыОдногоВида;
	Настройка.РаботаетСВнешнимиРесурсами = Ложь;
	Настройка.ВключатьПриВключенииФункциональнойОпции = Истина;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ABCКлассификацияНоменклатуры;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьABCXYZКлассификациюНоменклатурыПоВаловойПрибыли;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ABCКлассификацияНоменклатуры;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьABCXYZКлассификациюНоменклатурыПоВыручке;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ABCКлассификацияНоменклатуры;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьABCXYZКлассификациюНоменклатурыПоКоличествуПродаж;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.XYZКлассификацияНоменклатуры;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьABCXYZКлассификациюНоменклатурыПоВаловойПрибыли;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.XYZКлассификацияНоменклатуры;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьABCXYZКлассификациюНоменклатурыПоВыручке;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.XYZКлассификацияНоменклатуры;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьABCXYZКлассификациюНоменклатурыПоКоличествуПродаж;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ABCКлассификацияПартнеров;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьABCXYZКлассификациюПартнеровПоВаловойПрибыли;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ABCКлассификацияПартнеров;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьABCXYZКлассификациюПартнеровПоВыручке;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ABCКлассификацияПартнеров;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьABCXYZКлассификациюПартнеровПоКоличествуПродаж;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.XYZКлассификацияПартнеров;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьABCXYZКлассификациюПартнеровПоВаловойПрибыли;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.XYZКлассификацияПартнеров;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьABCXYZКлассификациюПартнеровПоВыручке;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.XYZКлассификацияПартнеров;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьABCXYZКлассификациюПартнеровПоКоличествуПродаж;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.АвтоматическоеНачислениеИСписаниеБонусныхБаллов;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьБонусныеПрограммыЛояльности;
	Настройка.Параметризуется     = Истина;
	Настройка.ВключатьПриВключенииФункциональнойОпции = Ложь;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.АнализДанныхДляОповещенийКлиентам;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьПочтовыйКлиент;
	Настройка.ВключатьПриВключенииФункциональнойОпции = Ложь;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.РасчетСебестоимости;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.РассчитыватьПредварительнуюСтоимостьРегламентнымЗаданием;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.РасчетИсточниковДанныхВариантовАнализа;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьМониторингЦелевыхПоказателей;
	Настройка.ВключатьПриВключенииФункциональнойОпции = Ложь;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОбновлениеНоменклатурыПродаваемойСовместно;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьНоменклатуруПродаваемуюСовместно;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.КорректировкаСтрокЗаказовМерныхТоваров;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьАвтоматическоеЗакрытиеСтрокЗаказовМерныхТоваров;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОбновлениеКодовТоваровПодключаемогоОборудования;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьОбменСПодключаемымОборудованиемOffline;
	Настройка.ВключатьПриВключенииФункциональнойОпции = Ложь;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОчисткаСегментов;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьСегментыНоменклатуры;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОчисткаСегментов;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьСегментыПартнеров;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.УдалениеВзаимодействийПоРассылкамИОповещениям;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьПочтовыйКлиент;
	Настройка.ВключатьПриВключенииФункциональнойОпции = Ложь;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ФормированиеСегментов;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьСегментыПартнеров;
	Настройка.Параметризуется     = Истина;
	Настройка.ВключатьПриВключенииФункциональнойОпции = Ложь;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ФормированиеСегментов;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьСегментыНоменклатуры;
	Настройка.Параметризуется     = Истина;
	Настройка.ВключатьПриВключенииФункциональнойОпции = Ложь;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ФормированиеСообщенийПоОповещениямКлиентов;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьПочтовыйКлиент;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ФормированиеСообщенийПоРассылкамКлиентам;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьПочтовыйКлиент;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ЗакрытиеМесяца;
	Настройка.ДоступноВПодчиненномУзлеРИБ = Ложь;
	
	
		
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОтправкаSMS;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОтправкаИПолучениеСообщенийСистемы;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.РассылкаОтчетов;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.СинхронизацияФайлов;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.РасчетРекомендацийПоддержанияЗапасов;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьРасширенноеОбеспечениеПотребностей;
	Настройка.ВключатьПриВключенииФункциональнойОпции = Ложь;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.СверткаРезервовТоваровОрганизаций;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьПередачиТоваровМеждуОрганизациями;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.СверткаРезервовТоваровОрганизаций;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьУправлениеПроизводством2_2;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ЗагрузкаКурсовВалютЕЦБ;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьЗагрузкуКурсовВалютЕЦБ;
	
	// СерверЛояльности
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.СерверЛояльностиОбработкаСостоянияБонусовПодарочныхСертификатов;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьСерверЛояльностиПоставщикДанных;
	Настройка.ВключатьПриВключенииФункциональнойОпции = Истина;
	// Конец СерверЛояльности
	
КонецПроцедуры

// Позволяет переопределить настройки подсистемы, заданные по умолчанию.
//
// Параметры:
//  Настройки - Структура:
//    * РасположениеКомандыСнятияБлокировки - Строка - определяет расположение команды снятия
//                                                     блокировки работы с внешними ресурсами
//                                                     при перемещении информационной базы.
//
Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
КонецПроцедуры


#КонецОбласти