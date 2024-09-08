﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	КассаККМ = Параметры.КассаККМ;
	Кассир = Параметры.Кассир;
	Организация = Параметры.Организация;
	СтруктураСостояниеКассовойСмены = РозничныеПродажи.ПолучитьСостояниеКассовойСмены(КассаККМ);
	КассоваяСмена = СтруктураСостояниеКассовойСмены.КассоваяСмена;
	
	ПараметрыКассыККМ = Справочники.КассыККМ.ПараметрыКассыККМ(КассаККМ);
	КассаККМИспользуетсяБезПодключенияОборудования = ПараметрыКассыККМ.ИспользоватьБезПодключенияОборудования;
	Период = Новый СтандартныйПериод(ВариантСтандартногоПериода.Сегодня);
	
	Если ЗначениеЗаполнено(КассоваяСмена) Тогда
		ИспользуетсяККТФЗ54 = РозничныеПродажиВызовСервера.ИспользуетсяККТФЗ54(КассоваяСмена);
	Иначе
		ИспользуетсяККТФЗ54 = Ложь;
	КонецЕсли;
		
	ЗаполнитьТаблицуТоваров();
	
	Склад = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КассаККМ, "Склад");
	
	Элементы.Период.Видимость                  = (ИспользуетсяККТФЗ54 Или КассаККМИспользуетсяБезПодключенияОборудования);
	Элементы.ТаблицаТоваровПомещение.Видимость = СкладыСервер.ИспользоватьСкладскиеПомещения(Склад, ТекущаяДатаСеанса());
	
	ИспользоватьНаборы                     = ПолучитьФункциональнуюОпцию("ИспользоватьНаборы");
	ИспользоватьХарактеристикиНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры");
	
	Элементы.ТаблицаТоваровНоменклатураНабора.Видимость   = ИспользоватьНаборы;
	Элементы.ТаблицаТоваровХарактеристикаНабора.Видимость = ИспользоватьНаборы И ИспользоватьХарактеристикиНоменклатуры;
	
	ЗаполнитьПредставленияЗаголовкаКнопкиОформитьВозвратНаСервере();
	Элементы.ФормаОформитьВозврат.Заголовок = ПредставленияЗаголовкаКнопкиОформитьВозврат.ОформитьВозврат;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОформитьВозврат(Команда)
	
	ОчиститьСообщения();
	Если ПодобраноПозиций = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Необходимо выбрать чек для оформления возврата по чеку.'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);		
		Возврат;
	Иначе
		ОткрытьФормуРМКДляОформленияЧекаККМВозврат();	
		Закрыть();
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуРМКДляОформленияЧекаККМВозврат()
	
	ПараметрыФормы = Новый Структура;	
	Строки = ТаблицаТоваров.НайтиСтроки(Новый Структура("Выбран", Истина));	
	ОтложенныйЧекККМВозврат = Строки[0].ОтложенныйЧекККМВозврат;	
	Если ЗначениеЗаполнено(ОтложенныйЧекККМВозврат) Тогда
		ПараметрыФормы.Вставить("Ключ", ОтложенныйЧекККМВозврат);
	Иначе
		ПодобранныйЧек = Строки[0].ЧекККМ;
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("Товары", АдресВоВременномХранилище(ПодобранныйЧек, ВладелецФормы.УникальныйИдентификатор));
		ПараметрыОткрытия.Вставить("ЧекККМ", ПодобранныйЧек);
		ПараметрыОткрытия.Вставить("Кассир", Кассир);
	
		ПараметрыФормы.Вставить("Основание", ПараметрыОткрытия);
	 КонецЕсли;
	
	ОткрытьФорму("Документ.ЧекККМВозврат.Форма.ФормаДокументаРМК", ПараметрыФормы, ВладелецФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТаблицаТоваровВыбранПриИзменении(Элемент)
	
	ПодобраноПозиций = 0;
	Всего            = 0;
	
	ТекущиеДанные = Элементы.ТаблицаТоваров.ТекущиеДанные;
	
	НоменклатураНабора   = ТекущиеДанные.НоменклатураНабора;
	ХарактеристикаНабора = ТекущиеДанные.ХарактеристикаНабора;
	
	ЧекККМ        = ТекущиеДанные.ЧекККМ;
	ОплаченКартой = ТекущиеДанные.ОплаченКартой;
	ЦенаЗадаетсяЗаНабор = ТекущиеДанные.ВариантРасчетаЦеныНабора = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоДолям")
						ИЛИ ТекущиеДанные.ВариантРасчетаЦеныНабора = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоЦенам");
	
	Для Каждого СтрокаТЧ Из ТаблицаТоваров Цикл
		Если СтрокаТЧ.ЧекККМ = ЧекККМ
			И (ОплаченКартой
				ИЛИ (СтрокаТЧ.НоменклатураНабора = НоменклатураНабора
				И СтрокаТЧ.ХарактеристикаНабора = ХарактеристикаНабора)) Тогда
			СтрокаТЧ.Выбран = ТекущиеДанные.Выбран;
		КонецЕсли;
		Если НЕ СтрокаТЧ.ЧекККМ = ЧекККМ Тогда
			СтрокаТЧ.Выбран = Ложь;
		КонецЕсли;
		Если СтрокаТЧ.Выбран Тогда
			ПодобраноПозиций = ПодобраноПозиций + 1;
			Всего = Всего + СтрокаТЧ.Сумма;
		КонецЕсли;			
	КонецЦикла;
	
	ОтложенныйЧекККМВозврат = ТекущиеДанные.ОтложенныйЧекККМВозврат;
	Если ЗначениеЗаполнено(ОтложенныйЧекККМВозврат) Тогда
		Элементы.ФормаОформитьВозврат.Заголовок = ПредставленияЗаголовкаКнопкиОформитьВозврат.ОткрытьОтложенныйВозврат;
	Иначе
		Элементы.ФормаОформитьВозврат.Заголовок = ПредставленияЗаголовкаКнопкиОформитьВозврат.ОформитьВозврат;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура ЗаполнитьПредставленияЗаголовкаКнопкиОформитьВозвратНаСервере()
	
	ПредставленияЗаголовкаКнопкиОформитьВозврат = Новый Структура;
	ПредставленияЗаголовкаКнопкиОформитьВозврат.Вставить("ОформитьВозврат", Команды.Найти(Элементы.ФормаОформитьВозврат.ИмяКоманды).Заголовок);
	ПредставленияЗаголовкаКнопкиОформитьВозврат.Вставить("ОткрытьОтложенныйВозврат", НСтр("ru = 'Открыть отложенный возврат'"));	
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция АдресВоВременномХранилище(ПодобранныйЧек, УникальныйИдентификатор)
	
	ПараметрыОтбора = Документы.ЧекККМ.ПараметрыДляПолученияНевозвращенныхПозицийПоЧекуККМ();
	ПараметрыОтбора.ЧекККМ = ПодобранныйЧек;
	ПараметрыОтбора.ИспользуетсяККТФЗ54 = Истина;

	ДанныеДляЗаполнения = Документы.ЧекККМ.ТаблицаНевозвращенныхПозицийПоЧекуККМ(ПараметрыОтбора);	
	Возврат ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, УникальныйИдентификатор);
	
КонецФункции
&НаСервере
Процедура ЗаполнитьТаблицуТоваров()
	
	ТаблицаТоваров.Очистить();
	
	ПараметрыОтбора = Документы.ЧекККМ.ПараметрыДляПолученияНевозвращенныхПозицийПоЧекуККМ();
	ПараметрыОтбора.КассаККМИспользуетсяБезПодключенияОборудования = КассаККМИспользуетсяБезПодключенияОборудования;
	ПараметрыОтбора.ИспользуетсяККТФЗ54 = ИспользуетсяККТФЗ54;
	ПараметрыОтбора.КассоваяСмена = КассоваяСмена;
	ПараметрыОтбора.НомерЧекаККМ = НомерЧекаККМ;
	ПараметрыОтбора.Номенклатура = Номенклатура;
	ПараметрыОтбора.КартаЛояльности = КартаЛояльности;
	ПараметрыОтбора.Период = Период;
	ПараметрыОтбора.Организация = Организация;
	
	ПодобраноПозиций = 0;
	Всего = 0;
	ПодобранныйЧек = Неопределено;
	
	ДанныеДляЗаполнения = Документы.ЧекККМ.ТаблицаНевозвращенныхПозицийПоЧекуККМ(ПараметрыОтбора);
	Для Каждого СтрокаДанныхДляЗаполнения Из ДанныеДляЗаполнения Цикл
		
		СтрокаТЧ = ТаблицаТоваров.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТЧ, СтрокаДанныхДляЗаполнения);
		
		Если ПодобранныйЧек = Неопределено Тогда
			Если ЗначениеЗаполнено(Номенклатура) Или ЗначениеЗаполнено(НомерЧекаККМ) Или ЗначениеЗаполнено(КартаЛояльности) Тогда
				ПодобранныйЧек = СтрокаТЧ.ЧекККМ;
			КонецЕсли;			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ПодобранныйЧек) И СтрокаТЧ.ЧекККМ = ПодобранныйЧек Тогда
			СтрокаТЧ.Выбран = Истина;
			ПодобраноПозиций = ПодобраноПозиций + 1;
			Всего = Всего + СтрокаТЧ.Сумма; 			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиТовары(Команда)
	
	ТаблицаТоваров.Очистить();
	ЗаполнитьТаблицуТоваров();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
