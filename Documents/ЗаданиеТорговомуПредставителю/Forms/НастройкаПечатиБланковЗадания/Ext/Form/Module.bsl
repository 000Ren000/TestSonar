﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ВосстановитьНастройки();

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПриИзмененииВыводаГрафикаОплаты();
	ПриИзмененииВыводаЗаметок();
	ПриИзмененииВыводаРасходов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВыводитьГрафикОплатыПриИзменении(Элемент)
	
	ПриИзмененииВыводаГрафикаОплаты();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьЗаметкиПриИзменении(Элемент)
	
	ПриИзмененииВыводаЗаметок();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьРасходыПриИзменении(Элемент)
	
	ПриИзмененииВыводаРасходов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)
	
	ХранилищеОбщихНастроекСохранить();
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура ХранилищеОбщихНастроекСохранить()
	
	ИмяОбъекта = "Документ.ЗаданиеТорговомуПредставителю.НастройкиПечатиБланковЗадания";
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(ИмяОбъекта, "ВыводитьЗадачиВСводномЗадании", ВыводитьЗадачиВСводномЗадании);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(ИмяОбъекта, "ВыводитьГрафикОплаты", ВыводитьГрафикОплаты);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(ИмяОбъекта, "ВыводитьЗадачи", ВыводитьЗадачи);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(ИмяОбъекта, "ВыводитьЗаметки", ВыводитьЗаметки);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(ИмяОбъекта, "ВыводитьРасходы", ВыводитьРасходы);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(ИмяОбъекта, "КоличествоСтрокГрафикаОплаты", КоличествоСтрокГрафикаОплаты);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(ИмяОбъекта, "КоличествоСтрокНоменклатуры", КоличествоСтрокНоменклатуры);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(ИмяОбъекта, "КоличествоСтрокЗаметок", КоличествоСтрокЗаметок);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(ИмяОбъекта, "КоличествоСтрокРасходов", КоличествоСтрокРасходов);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриИзмененииРеквизитов

&НаКлиенте
Процедура ПриИзмененииВыводаГрафикаОплаты()
	
	Элементы.КоличествоСтрокГрафикаОплаты.Доступность = ВыводитьГрафикОплаты;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииВыводаЗаметок()
	
	Элементы.КоличествоСтрокЗаметок.Доступность = ВыводитьЗаметки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииВыводаРасходов()
	
	Элементы.КоличествоСтрокРасходов.Доступность = ВыводитьРасходы;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ВосстановитьНастройки()
	
	ИмяОбъекта = "Документ.ЗаданиеТорговомуПредставителю.НастройкиПечатиБланковЗадания";
	СтруктураЗначенийПараметровПоУмолчанию = ЗначенияПараметровПоУмолчанию();
	
	ВыводитьЗадачиВСводномЗадании = ПолучитьЗначениеПараметраНастройки(ИмяОбъекта, "ВыводитьЗадачиВСводномЗадании", СтруктураЗначенийПараметровПоУмолчанию);
	ВыводитьГрафикОплаты = ПолучитьЗначениеПараметраНастройки(ИмяОбъекта, "ВыводитьГрафикОплаты", СтруктураЗначенийПараметровПоУмолчанию);
	ВыводитьЗадачи = ПолучитьЗначениеПараметраНастройки(ИмяОбъекта, "ВыводитьЗадачи", СтруктураЗначенийПараметровПоУмолчанию);
	ВыводитьЗаметки = ПолучитьЗначениеПараметраНастройки(ИмяОбъекта, "ВыводитьЗаметки", СтруктураЗначенийПараметровПоУмолчанию);
	ВыводитьРасходы = ПолучитьЗначениеПараметраНастройки(ИмяОбъекта, "ВыводитьРасходы", СтруктураЗначенийПараметровПоУмолчанию);
	
	КоличествоСтрокГрафикаОплаты = ПолучитьЗначениеПараметраНастройки(ИмяОбъекта, "КоличествоСтрокГрафикаОплаты", СтруктураЗначенийПараметровПоУмолчанию);
	КоличествоСтрокНоменклатуры = ПолучитьЗначениеПараметраНастройки(ИмяОбъекта, "КоличествоСтрокНоменклатуры", СтруктураЗначенийПараметровПоУмолчанию);
	КоличествоСтрокЗаметок = ПолучитьЗначениеПараметраНастройки(ИмяОбъекта, "КоличествоСтрокЗаметок", СтруктураЗначенийПараметровПоУмолчанию);
	КоличествоСтрокРасходов = ПолучитьЗначениеПараметраНастройки(ИмяОбъекта, "КоличествоСтрокРасходов", СтруктураЗначенийПараметровПоУмолчанию);
	
КонецПроцедуры

&НаСервере
// Получает и возвращает значение параметра настройки.
//
// Параметры:
//  ИмяОбъекта - Имя объекта настройки.
//  ИмяПараметра - имя параметра настройки.
//  СтруктураЗначенийПараметровПоУмолчанию - структура, содержащая значения параметров по умолчанию.
//
// Возвращаемое значение:
//  Значение параметра.
//
Функция ПолучитьЗначениеПараметраНастройки(ИмяОбъекта, ИмяПараметра, СтруктураЗначенийПараметровПоУмолчанию)
	
	ЗначениеПараметра = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(ИмяОбъекта, ИмяПараметра);
	
	Если ЗначениеПараметра <> Неопределено Тогда
		Возврат ЗначениеПараметра;
	Иначе
		ЗначениеПоУмолчанию = Неопределено;
		СтруктураЗначенийПараметровПоУмолчанию.Свойство(ИмяПараметра, ЗначениеПоУмолчанию);
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;
	
КонецФункции

&НаСервере
// Формирует и возвращает структуру, содержащую значения параметров по умолчанию.
//
// Возвращаемое значение:
//  Структура, содержащая значения параметров по умолчанию.
//
Функция ЗначенияПараметровПоУмолчанию()
	
	СтруктураПараметров = Новый Структура();
	
	СтруктураПараметров.Вставить("ВыводитьЗадачиВСводномЗадании", Ложь);
	СтруктураПараметров.Вставить("ВыводитьГрафикОплаты", Истина);
	СтруктураПараметров.Вставить("ВыводитьЗадачи", Истина);
	СтруктураПараметров.Вставить("ВыводитьЗаметки", Истина);
	СтруктураПараметров.Вставить("ВыводитьРасходы", Истина);
	
	СтруктураПараметров.Вставить("КоличествоСтрокГрафикаОплаты", 3);
	СтруктураПараметров.Вставить("КоличествоСтрокНоменклатуры", 5);
	СтруктураПараметров.Вставить("КоличествоСтрокЗаметок", 5);
	СтруктураПараметров.Вставить("КоличествоСтрокРасходов", 5);
	
	Возврат СтруктураПараметров;
	
КонецФункции

#КонецОбласти

#КонецОбласти
