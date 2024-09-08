﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры.РеквизитыДляЗаполнения, , "Периодичность, РеквизитыРасчетаСезонности");
	Периодичность = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Владелец, "Периодичность");
	РеквизитыРасчетаСезонностиОбъекта = ПолучитьИзВременногоХранилища(Параметры.РеквизитыДляЗаполнения.РеквизитыРасчетаСезонности);
	РеквизитыРасчетаСезонности.Загрузить(РеквизитыРасчетаСезонностиОбъекта);
	
	Если ТипПлана = Перечисления.ТипыПланов.ПланПродажПоКатегориям Тогда
		ТекстВариантыПрогнозированияПоКатегориям = НСтр("ru = 'Выбранный вариант определяет, в каком виде данные прогнозов будут выводиться для анализа:
			| %1 Только по категориям   - данные выводятся по категориям.
			| %1 С разбивкой по товарам - данные выводятся по товарам.'");
		ТекстВариантыПрогнозированияПоКатегориям = СтрШаблон(ТекстВариантыПрогнозированияПоКатегориям, Символ(8226));
		Элементы.ДекорацияВариантПрогнозированияПоКатегориям.Подсказка = ТекстВариантыПрогнозированияПоКатегориям;
	КонецЕсли;
	
	ПересчитатьДанныеЗависимыеОтНачалаПрогнозирования();
	//++ Локализация
	ПересчитатьДатуПоследнейПродажи();
	//-- Локализация
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ПодборРеквизитовКоллекцийВыборРеквизита" Тогда
		Если Не ПустаяСтрока(Параметр.ИмяВИсточнике) Тогда
			НоваяСтрока = РеквизитыРасчетаСезонности.Добавить();
			НоваяСтрока.ИмяВИсточнике = Параметр.ИмяВИсточнике;
			НоваяСтрока.ИмяВСервисе = Параметр.ИмяВСервисе;
			НоваяСтрока.Представление = Параметр.Представление;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//++ Локализация
	Если Не ПустаяСтрока(ИдентификаторЗаданияОбновитьДатуПродажи) Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ОбновитьДатуПродажиНаКлиенте", 1, Истина);
	КонецЕсли;
	//-- Локализация
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НачалоПрогнозированияПриИзменении(Элемент)
	
	ПересчитатьДанныеЗависимыеОтНачалаПрогнозирования();
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключатьСезонностьПриИзменении(Элемент)
	УстановитьВидимостьДоступность();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьРеквизитСезонности(Команда)
	
	//++ Локализация
	ПараметрыПодбора = Новый Структура();
	ПараметрыПодбора.Вставить("ИмяВИсточнике", "Товары");
	ПараметрыПодбора.Вставить("ИмяВСервисе", "products");
	ПараметрыПодбора.Вставить("ЗаблокироватьФлагВыбора", Истина);
	ПараметрыПодбора.Вставить("Выбрано", Истина);
	ПараметрыПодбора.Вставить("РежимВыбора", Истина);
	ПараметрыПодбора.Вставить("ПоказыватьТолькоВыбранные", Истина);
	
	ОткрытьФорму("Обработка.ПанельУправленияСервисомПрогнозирования.Форма.ФормаПодбораРеквизитовКоллекций",
		ПараметрыПодбора,
		ЭтаФорма,
		,
		,
		,
		,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	//-- Локализация
		
КонецПроцедуры

&НаКлиенте
Процедура Ок(Команда)
	
	//++ Локализация
	СписокРеквизитовДляРедактирования = СервисПрогнозированияПереопределяемыйКлиентСервер.РеквизитыВидаПланаДляСервисаПрогнозирования();
	ПараметрыФормыРедактирования = Новый Структура(СписокРеквизитовДляРедактирования);
	ЗаполнитьЗначенияСвойств(ПараметрыФормыРедактирования, ЭтаФорма, , "РеквизитыРасчетаСезонности");
	
	АдресВременногоХранилища = ПоместитьРеквизитыРасчетаСезонностиВоВременноеХранилище();
	ПараметрыФормыРедактирования.Вставить("РеквизитыРасчетаСезонности", АдресВременногоХранилища);
	
	Закрыть(ПараметрыФормыРедактирования);
	//-- Локализация
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимостьДоступность()
	
	Элементы.РеквизитыСезонности.Доступность = Не ИсключатьСезонность;
	Элементы.ДеньНеделиНачалаПрогноза.Видимость = (Периодичность = Перечисления.Периодичность.Неделя);
	Элементы.ГруппаНадписьУстановленыДатыЗапретаИзменений.Видимость = ЕстьЗапретИзмененияДанных;
	Элементы.ГруппаВариантПрогнозированияПоКатегориям.Видимость = ТипПлана = Перечисления.ТипыПланов.ПланПродажПоКатегориям;
	
КонецПроцедуры

&НаСервере
Процедура ПересчитатьДанныеЗависимыеОтНачалаПрогнозирования()
	
	ДанныеДляПроверки  = ДатыЗапретаИзменения.ШаблонДанныхДляПроверки();
	
	НоваяСтрока        = ДанныеДляПроверки.Добавить();
	НоваяСтрока.Дата   = НачалоДня(НачалоПрогнозирования);
	НоваяСтрока.Раздел = "Планирование";
	НоваяСтрока.Объект = Владелец;
	
	ОписаниеДанных = Новый Структура("НоваяВерсия, Данные", Ложь, "");
	
	ЕстьЗапретИзмененияДанных = Ложь;
	ОписаниеОшибки = "";
	Если ДатыЗапретаИзменения.НайденЗапретИзмененияДанных(ДанныеДляПроверки, ОписаниеДанных, ОписаниеОшибки) Тогда
		ЕстьЗапретИзмененияДанных = Истина;
	КонецЕсли;
	
КонецПроцедуры

//++ Локализация

&НаСервере
Функция ПоместитьРеквизитыРасчетаСезонностиВоВременноеХранилище()
	АдресВременногоХранилища = ПоместитьВоВременноеХранилище(
				РеквизитыРасчетаСезонности.Выгрузить(),
				УникальныйИдентификатор);
	Возврат АдресВременногоХранилища;
КонецФункции

&НаКлиенте
Процедура Подключаемый_ОбновитьДатуПродажиНаКлиенте()
	Подключаемый_ОбновитьДатуПродажиНаСервере();
	Если Не ПустаяСтрока(ИдентификаторЗаданияОбновитьДатуПродажи) Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ОбновитьДатуПродажиНаКлиенте", 1, Истина);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОбновитьДатуПродажиНаСервере(ВыполнениеПроверено = Ложь)
	Если ВыполнениеПроверено
		Или Не ПустаяСтрока(ИдентификаторЗаданияОбновитьДатуПродажи)
			И ДлительныеОперации.ЗаданиеВыполнено(Новый УникальныйИдентификатор(ИдентификаторЗаданияОбновитьДатуПродажи)) Тогда
		ИдентификаторЗаданияОбновитьДатуПродажи = "";
		
		ПоследняяИзвестнаяПродажа = ПолучитьИзВременногоХранилища(АдресХранилищаОбновитьДатуПродажи);
		
		Элементы.ПоследняяИзвестнаяПродажаИдетВычисление.Видимость = Ложь;
		Элементы.ПоследняяИзвестнаяПродажа.Видимость = Истина;
		
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПересчитатьДатуПоследнейПродажи()
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	
	РезультатРасчета = ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения,
		"СервисПрогнозированияПереопределяемый.ПоследняяИзвестнаяДатаПродажи");
	
	Если РезультатРасчета.Статус = "Выполняется" Тогда
		ИдентификаторЗаданияОбновитьДатуПродажи = РезультатРасчета.ИдентификаторЗадания;
		АдресХранилищаОбновитьДатуПродажи = РезультатРасчета.АдресРезультата;
	ИначеЕсли РезультатРасчета.Статус = "Выполнено" Тогда
		АдресХранилищаОбновитьДатуПродажи = РезультатРасчета.АдресРезультата;
		Подключаемый_ОбновитьДатуПродажиНаСервере(Истина);
	КонецЕсли;
	
КонецПроцедуры

//-- Локализация

#КонецОбласти
