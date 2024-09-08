﻿#Если НЕ МобильныйАвтономныйСервер Тогда
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ФормироватьРабочееНаименование =		Не (ДополнительныеСвойства.Свойство("РабочееНаименованиеСформировано"));
	ФормироватьНаименованиеДляПечати =		Не (ДополнительныеСвойства.Свойство("НаименованиеДляПечатиСформировано"));
	
	УстановитьРеквизитыЦенообразования = Ложь;
	Если Не ДополнительныеСвойства.Свойство("ИспользуетсяЦенообразование25", УстановитьРеквизитыЦенообразования) Тогда
		УстановитьРеквизитыЦенообразования = ЦенообразованиеВызовСервера.ИспользуетсяЦенообразование25();
	КонецЕсли;
	
	Если ТипЗнч(Владелец) = Тип("СправочникСсылка.ВидыНоменклатуры") Тогда
		ВидНоменклатуры = Владелец;
	Иначе
		ВидНоменклатуры = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Владелец, "ВидНоменклатуры");
	КонецЕсли;
	
	Если ФормироватьРабочееНаименование 
		Или ФормироватьНаименованиеДляПечати
		Или УстановитьРеквизитыЦенообразования Тогда

		СтруктураРеквизитов = Новый Структура;

		СтруктураРеквизитов.Вставить("ШаблонРабочегоНаименованияХарактеристики");
		СтруктураРеквизитов.Вставить("ЗапретРедактированияРабочегоНаименованияХарактеристики");
		СтруктураРеквизитов.Вставить("ШаблонНаименованияДляПечатиХарактеристики");
		СтруктураРеквизитов.Вставить("ЗапретРедактированияНаименованияДляПечатиХарактеристики");
		СтруктураРеквизитов.Вставить("НастройкиКлючаЦенПоХарактеристике");
		
		РеквизитыОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВидНоменклатуры, СтруктураРеквизитов);

		Если ФормироватьРабочееНаименование
				И ЗначениеЗаполнено(РеквизитыОбъекта.ШаблонРабочегоНаименованияХарактеристики)
				И (РеквизитыОбъекта.ЗапретРедактированияРабочегоНаименованияХарактеристики
				Или Не ЗначениеЗаполнено(Наименование)) Тогда
			ШаблонНаименования = РеквизитыОбъекта.ШаблонРабочегоНаименованияХарактеристики;
			Наименование = НоменклатураСервер.НаименованиеПоШаблону(ШаблонНаименования, ЭтотОбъект);
		КонецЕсли;
		
		Если ФормироватьНаименованиеДляПечати
			И ЗначениеЗаполнено(РеквизитыОбъекта.ШаблонНаименованияДляПечатиХарактеристики) 
			И (РеквизитыОбъекта.ЗапретРедактированияНаименованияДляПечатиХарактеристики 
			Или Не ЗначениеЗаполнено(НаименованиеПолное)) Тогда
			ШаблонНаименованияДляПечати = РеквизитыОбъекта.ШаблонНаименованияДляПечатиХарактеристики;
			НаименованиеПолное = НоменклатураСервер.НаименованиеПоШаблону(ШаблонНаименованияДляПечати, ЭтотОбъект);
		КонецЕсли;
		
		НастройкиКлючаЦен = РеквизитыОбъекта.НастройкиКлючаЦенПоХарактеристике;
		Если УстановитьРеквизитыЦенообразования 
			И ЗначениеЗаполнено(НастройкиКлючаЦен)
			И НастройкиКлючаЦен <> Перечисления.ВариантОтбораДляКлючаЦен.НеИспользовать Тогда
			
			РеквизитыДляПоиска = ПолучитьРеквизитыДляПоиска(ВидНоменклатуры, РеквизитыОбъекта);
			ХарактеристикаНоменклатурыДляЦенообразования = ПолучитьХарактеристикуНоменклатурыДляЦенообразования(РеквизитыДляПоиска);
			
			Если ЗначениеЗаполнено(ХарактеристикаНоменклатурыДляЦенообразования)
				И Не ЭтоНовый() Тогда

				СтарыеЗначения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "ПометкаУдаления"); 
				
				Если ПометкаУдаления <> СтарыеЗначения.ПометкаУдаления Тогда
					
					ПараметрыСинхронизации = Новый Структура();
					ПараметрыСинхронизации.Вставить("ПометкаУдаления", ПометкаУдаления);
					ПараметрыСинхронизации.Вставить("ХарактеристикаНоменклатуры", Ссылка);
					ПараметрыСинхронизации.Вставить("ХарактеристикаНоменклатурыДляЦенообразования", ХарактеристикаНоменклатурыДляЦенообразования);
					
					Справочники.ХарактеристикиНоменклатурыДляЦенообразования.СинхронизироватьПометкуУдаления(ПараметрыСинхронизации);
					
				КонецЕсли;
	
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Наименование) Тогда
		ТекстИсключения = НСтр("ru='Поле ""Рабочее наименование"" не заполнено'");
		ВызватьИсключение ТекстИсключения; 
	КонецЕсли;
	
	КонтролироватьРабочееНаименование =
		Константы.КонтролироватьУникальностьРабочегоНаименованияНоменклатурыИХарактеристик.Получить()
		И НЕ (ДополнительныеСвойства.Свойство("РабочееНаименованиеПроверено"));
	
	Если КонтролироватьРабочееНаименование
		И Не Отказ Тогда
		Если Не Справочники.ХарактеристикиНоменклатуры.РабочееНаименованиеУникально(ЭтотОбъект) Тогда
			ТекстИсключения = НСтр("ru='Значение поля ""Рабочее наименование"" не уникально'");
			ВызватьИсключение ТекстИсключения; 
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Принципал)
		И ТипЗнч(Принципал) = Тип("СправочникСсылка.Организации") Тогда
		Контрагент = Принципал;
	КонецЕсли;
	
	ОбщегоНазначенияУТ.ПодготовитьДанныеДляСинхронизацииКлючей(ЭтотОбъект, ПараметрыСинхронизацииКлючей());

КонецПроцедуры // ПередЗаписью()

Процедура ПриКопировании(ОбъектКопирования)
	ХарактеристикаНоменклатурыДляЦенообразования = Справочники.ХарактеристикиНоменклатурыДляЦенообразования.ПустаяСсылка();
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияУТ.СинхронизироватьКлючи(ЭтотОбъект);	
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ШтрихкодыНоменклатуры.Штрихкод КАК Штрихкод
	|ИЗ
	|	РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	|ГДЕ
	|	ШтрихкодыНоменклатуры.Характеристика = &Характеристика";
	
	Запрос.УстановитьПараметр("Характеристика", Ссылка);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НаборЗаписей = РегистрыСведений.ШтрихкодыНоменклатуры.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Штрихкод.Значение = Выборка.Штрихкод;
		НаборЗаписей.Отбор.Штрихкод.Использование = Истина;
		НаборЗаписей.Записать();
	КонецЦикла;
	
КонецПроцедуры // ПередУдалением()

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Справочники.ХарактеристикиНоменклатуры.НепроверяемыеРеквизиты(ЭтотОбъект);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	НоменклатураЛокализация.ОбработкаПроверкиЗаполненияХарактеристикиНоменклатуры(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПриЧтенииПредставленийНаСервере() Экспорт
	// СтандартныеПодсистемы.БазоваяФункциональность
	МультиязычностьСервер.ПриЧтенииПредставленийНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
КонецПроцедуры

// Получить реквизиты для поиска.
// 
// Параметры:
//  ВидНоменклатуры - СправочникСсылка.ВидыНоменклатуры - Вид номенклатуры
//  РеквизитыОбъекта - Структура - Реквизиты объекта
//  ПроизвестиПоискХЦО - Булево - Произвести поиск ХЦО
// 
// Возвращаемое значение:
//  Структура - Получить реквизиты для поиска:
// * ТекущаяХарактеристика - СправочникСсылка.ХарактеристикиНоменклатуры -
// * ТекущаяХарактеристикаЦО - СправочникСсылка.ХарактеристикиНоменклатурыДляЦенообразования -
// * ПроизвестиПоискХЦО - Булево -
// * ВидНоменклатуры - СправочникСсылка.ВидыНоменклатуры -
// * СсылкаОдинКОдному - Булево - Истин, на основании характеристики только одна характеристика ценообразования
// * РеквизитыДляКлючаЦен - ТаблицаЗначений -
Функция ПолучитьРеквизитыДляПоиска(Знач ВидНоменклатуры, Знач РеквизитыОбъекта, Знач ПроизвестиПоискХЦО = Истина) Экспорт

	// получить список доп реквизитов по которым искать хар-ку
	РеквизитыДляКлючаЦен = Справочники.ВидыНоменклатуры.ПолучитьРеквизитыДляКлючаЦен(ВидНоменклатуры, "Характеристики");

	РеквизитыДляПоиска = Новый Структура;
	РеквизитыДляПоиска.Вставить("ТекущаяХарактеристика",      Ссылка);
	РеквизитыДляПоиска.Вставить("ТекущаяХарактеристикаЦО",    ХарактеристикаНоменклатурыДляЦенообразования);
	РеквизитыДляПоиска.Вставить("ПроизвестиПоискХЦО",         ПроизвестиПоискХЦО);
	РеквизитыДляПоиска.Вставить("ВидНоменклатуры",            ВидНоменклатуры);
	РеквизитыДляПоиска.Вставить("СсылкаОдинКОдному",          Ложь);

	Если РеквизитыОбъекта.НастройкиКлючаЦенПоХарактеристике = Перечисления.ВариантОтбораДляКлючаЦен.ИспользоватьПоРеквизитам Тогда
		ДанныеПоДополнительнымРеквизитам = ДополнительныеРеквизиты.Выгрузить(); 

		Для Каждого СтрокаРеквизитаДляКлючаЦен Из РеквизитыДляКлючаЦен Цикл
			Если СтрокаРеквизитаДляКлючаЦен.ЭтоДопРеквизит Тогда
				НайденнаяСтрока = ДанныеПоДополнительнымРеквизитам.Найти(СтрокаРеквизитаДляКлючаЦен.Свойство, "Свойство");
				СтрокаРеквизитаДляКлючаЦен.Значение = НайденнаяСтрока.Значение;
			Иначе
				СтрокаРеквизитаДляКлючаЦен.Значение = ЭтотОбъект[СтрокаРеквизитаДляКлючаЦен.ИмяРеквизита];
			КонецЕсли;
		КонецЦикла;
	Иначе // по всем реквизитам для ценообразования
		РеквизитыДляПоиска.Вставить("СсылкаОдинКОдному",          Истина);
		Для Каждого Строка Из ДополнительныеРеквизиты Цикл
			СтрокаРеквизитаДляКлючаЦен = РеквизитыДляКлючаЦен.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаРеквизитаДляКлючаЦен, Строка);
			СтрокаРеквизитаДляКлючаЦен.ИмяРеквизита = Строка.Свойство;
			СтрокаРеквизитаДляКлючаЦен.ЭтоДопРеквизит = Истина;
			СтрокаРеквизитаДляКлючаЦен.Используется = Истина;
		КонецЦикла;

		СтрокаРеквизитаДляКлючаЦен = РеквизитыДляКлючаЦен.Добавить();
		СтрокаРеквизитаДляКлючаЦен.ИмяРеквизита   = "Наименование";
		СтрокаРеквизитаДляКлючаЦен.Значение       = Наименование;
		СтрокаРеквизитаДляКлючаЦен.ЭтоДопРеквизит = Ложь;
		СтрокаРеквизитаДляКлючаЦен.Используется   = Истина;
		
		Если ТипЗнч(Владелец) = Тип("СправочникСсылка.Номенклатура") Тогда
			СтрокаРеквизитаДляКлючаЦен = РеквизитыДляКлючаЦен.Добавить();
			СтрокаРеквизитаДляКлючаЦен.ИмяРеквизита   = "Номенклатура";
			СтрокаРеквизитаДляКлючаЦен.Значение       = Владелец;
			СтрокаРеквизитаДляКлючаЦен.ЭтоДопРеквизит = Ложь;
			СтрокаРеквизитаДляКлючаЦен.Используется   = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	РеквизитыДляПоиска.Вставить("РеквизитыДляКлючаЦен",       РеквизитыДляКлючаЦен);
	
	Возврат РеквизитыДляПоиска
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПараметрыСинхронизацииКлючей()
	
	Результат = Новый Соответствие;
	
	Результат.Вставить("Справочник.КлючиАналитикиУчетаНаборов", "ПометкаУдаления");
	Результат.Вставить("Справочник.КлючиАналитикиУчетаНоменклатуры", "ПометкаУдаления");
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьХарактеристикуНоменклатурыДляЦенообразования(РеквизитыДляПоиска)
	
	Возврат Справочники.ХарактеристикиНоменклатурыДляЦенообразования.ПолучитьХарактеристикуНоменклатурыДляЦенообразования(РеквизитыДляПоиска);
	
КонецФункции 

#КонецОбласти

#КонецЕсли
#КонецЕсли
