﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере
//
Процедура ПередЗагрузкойВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	
	// Изменение настроек по функциональным опциям
	НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы);
	
	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий
//определяет возможные размеры для картинок отчета
Функция УстановитьРазмерИзображений(РазмерИзображений)
	
	ВысотаСтроки = 60;
	ШиринаКолонки = 20;	
	
	Если РазмерИзображений = Перечисления.РазмерКартинок.Маленькие Тогда
		ВысотаСтроки 	= 40;
		ШиринаКолонки = 13;
	ИначеЕсли РазмерИзображений = Перечисления.РазмерКартинок.Средние Тогда
		ВысотаСтроки 	= 60;
		ШиринаКолонки = 20;
	ИначеЕсли РазмерИзображений = Перечисления.РазмерКартинок.Большие Тогда
		ВысотаСтроки 	= 120;
		ШиринаКолонки = 40;
	КонецЕсли;
	
	Структура = Новый Структура;
	Структура.Вставить("ВысотаСтроки",ВысотаСтроки);
	Структура.Вставить("ШиринаКолонки",ШиринаКолонки);
	
	Возврат Структура;
	
КонецФункции

Процедура НастроитьВыводКартинок(ВыводитьИзображение) 
	ДоступныеПоляКомпоновкиНастроек = ЭтотОбъект.КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы;
	ДоступныеПоляКомпоновкиНастроекНоменклатура = ДоступныеПоляКомпоновкиНастроек.Найти("Номенклатура");
	Если ДоступныеПоляКомпоновкиНастроекНоменклатура<>Неопределено Тогда
		НастройкиСтруктура =  ЭтотОбъект.КомпоновщикНастроек.Настройки.Структура;
		Для Инд = 0 По НастройкиСтруктура.Количество()-1 Цикл
			ЭлСтруктуры = НастройкиСтруктура.Получить(Инд);
			Если ТипЗнч(ЭлСтруктуры) = Тип("ТаблицаКомпоновкиДанных") Тогда
				ТаблицаКомпоновкиДанных = ЭлСтруктуры;
				Для каждого Стр Из ТаблицаКомпоновкиДанных.Строки Цикл
					ТаблицаКомпоновкиДанныхСтрокиСтруктура = Стр.Структура;
					ОбработатьТаблицуКомпоновкиДанных(ВыводитьИзображение, ТаблицаКомпоновкиДанныхСтрокиСтруктура);	
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

Процедура ОбработатьТаблицуКомпоновкиДанных(Знач ВыводитьИзображение, ТаблицаКомпоновкиДанныхСтрокиСтруктура)
	Для ИндСтр = 0 По ТаблицаКомпоновкиДанныхСтрокиСтруктура.Количество()-1 Цикл
		СтрТаб = ТаблицаКомпоновкиДанныхСтрокиСтруктура.Получить(ИндСтр);
		Если ТипЗнч(СтрТаб) = Тип("ГруппировкаТаблицыКомпоновкиДанных") Тогда
			ЭлементыВыбораСтруктуры = ТаблицаКомпоновкиДанныхСтрокиСтруктура.Получить(ИндСтр).Выбор.Элементы;
			Для ИндЭл = 0 По ЭлементыВыбораСтруктуры.Количество()-1 Цикл
				Эл = ЭлементыВыбораСтруктуры.Получить(ИндЭл);
				Если ТипЗнч(Эл) = Тип("ВыбранноеПолеКомпоновкиДанных") И Эл.Поле = Новый ПолеКомпоновкиДанных("Номенклатура.ФайлКартинки") Тогда
					Эл.Использование = ВыводитьИзображение;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		ТаблицаКомпоновкиДанныхСтрокиСтруктура = СтрТаб.Структура;
		ОбработатьТаблицуКомпоновкиДанных(ВыводитьИзображение, ТаблицаКомпоновкиДанныхСтрокиСтруктура);
	КонецЦикла;
КонецПроцедуры

// Параметры:
// 	ДокументРезультат - ТабличныйДокумент
// 	ДанныеРасшифровки - ДанныеРасшифровкиКомпоновкиДанных
// 	СтандартнаяОбработка - Булево
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ТекстЗапроса = СхемаКомпоновкиДанных.НаборыДанных.ПрайсЛист.Запрос;
	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса, 
		"&ТекстЗапросаКоэффициентУпаковки", 
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"ЦеныНоменклатурыСрезПоследних.Упаковка", 
			"ЦеныНоменклатурыСрезПоследних.Номенклатура"));
		
	ТекстЗапроса = СтрЗаменить(
	ТекстЗапроса, 
	"&ТекстЗапросаВторойКоэффициентУпаковки", 
	Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
	"КомплектующиеНабораЦеныПоНабору.Упаковка", 
	"КомплектующиеНабораЦеныПоНабору.Номенклатура"));

	Поля = "ОстатокНаСкладе.Номенклатура,ОстатокНаСкладе.Характеристика,ОстатокНаСкладе.Склад";
	ТекстЗапроса = РегистрыСведений.ТоварныеОграничения.ПодставитьСоединение(ТекстЗапроса, "ПодстановкаТоварногоОграничения", Поля);
	
	НаборыВыводятся = ВОтчетеВыводятсяНаборыНоменклатуры(КомпоновщикНастроек);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&НаборыВыводятся", ?(НаборыВыводятся, "Истина", "Ложь"));
	
	СхемаКомпоновкиДанных.НаборыДанных.ПрайсЛист.Запрос = ТекстЗапроса;
	
	СегментыСервер.ВключитьОтборПоСегментуНоменклатурыВСКД(КомпоновщикНастроек);
	
	АссортиментСервер.ВключитьОтборПоАссортиментуВСКД(КомпоновщикНастроек);
	
	ПараметрыДанныхКомпоновщика = КомпоновщикНастроек.ПолучитьНастройки().ПараметрыДанных;
	ПараметрРазмерИзображений = ПараметрыДанныхКомпоновщика.Элементы.Найти("РазмерИзображений");
	Если ПараметрРазмерИзображений <> Неопределено Тогда
		СтруктураРазмера =  УстановитьРазмерИзображений(ПараметрРазмерИзображений.Значение);
		ВыводитьИзображение = ПараметрРазмерИзображений.Использование;
	Иначе
		ВыводитьИзображение = Ложь;
	КонецЕсли;
	
	НастроитьВыводКартинок(ВыводитьИзображение);
	
	Если ВыводитьИзображение Тогда
		
		СтандартнаяОбработка = Ложь;
		
		КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
		Макет = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек.ПолучитьНастройки(), ДанныеРасшифровки);	
		
		ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
		ПроцессорКомпоновки.Инициализировать(Макет, , ДанныеРасшифровки, Истина);
		
		ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
		ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
		ПроцессорВывода.Вывести(ПроцессорКомпоновки);
		
		//Корректировка документа результата
		КолКолонок = ДокументРезультат.ШиринаТаблицы;
		КолСтрок =   ДокументРезультат.ВысотаТаблицы;
		
		Для Кол = 1 По КолКолонок Цикл
			
			Для Стр = 1 По КолСтрок Цикл
				
				ТекЯчейка = ДокументРезультат.Область(Стр, Кол);
				Если ТекЯчейка.Расшифровка <> Неопределено Тогда
					
					ПоляРасшифровки = ДанныеРасшифровки.Элементы[ТекЯчейка.Расшифровка].ПолучитьПоля();
					
					Если ПоляРасшифровки.Количество() > 0 Тогда
						
						ТекПолеРасшифровки = ПоляРасшифровки[0].Значение;
						
						Если ТипЗнч(ТекПолеРасшифровки) = Тип("СправочникСсылка.НоменклатураПрисоединенныеФайлы") 
							и ЗначениеЗаполнено(ТекПолеРасшифровки)  Тогда
							
							Рисунок = РаботаСФайлами.ДвоичныеДанныеФайла(ТекПолеРасшифровки);
							Если Рисунок <> Неопределено Тогда
								
								ТекЯчейка.ВысотаСтроки 	= СтруктураРазмера.ВысотаСтроки;
								ТекЯчейка.ШиринаКолонки = СтруктураРазмера.ШиринаКолонки;
								
								Рис = ДокументРезультат.Рисунки.Добавить(ТипРисункаТабличногоДокумента.Картинка);
								Рис.РазмерКартинки = РазмерКартинки.Пропорционально;
								Рис.Картинка = Новый картинка(Рисунок);
								Рис.Расположить(ТекЯчейка);
								
							КонецЕсли;
							
						КонецЕсли;
						
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
	
Процедура НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВидовЦен") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(КомпоновщикНастроекФормы, "ВидЦены");
	КонецЕсли;
	
КонецПроцедуры

Функция ВОтчетеВыводятсяНаборыНоменклатуры(КомпоновщикНастроек)
	
	НаборыВыводятся = Ложь;
	ЗначениеПоиска  = Новый ПолеКомпоновкиДанных("НаборНоменклатуры");
	
	Для Каждого Группировка Из КомпоновкаДанныхКлиентСервер.ПолучитьГруппировки(КомпоновщикНастроек.ПолучитьНастройки()) Цикл
		Если Группировка.Значение.Использование Тогда
			ПоляГруппировки = Группировка.Значение.ПоляГруппировки; // ПоляГруппировкиКомпоновкиДанных
			Для Каждого Элемент Из ПоляГруппировки.Элементы Цикл
				Если Элемент.Использование И Элемент.Поле = ЗначениеПоиска Тогда
					НаборыВыводятся = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		Если НаборыВыводятся Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат НаборыВыводятся;
	
Конецфункции

#КонецОбласти

#КонецЕсли