﻿#Область ПрограммныйИнтерфейс

// Очистить реквизиты в зависимости от условия применения
//
// Параметры:
//  Объект - СправочникОбъект.УсловияПредоставленияСкидокНаценок - Элемент справочника.
//
Процедура ОчиститьРеквизитыВЗависимостиОтУсловияПрименения(Объект) Экспорт
	
	Если Объект.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаВсеРеквизиты = "ВариантОпределенияПериодаНакопительнойСкидки, ВариантНакопления, 
	                      |КритерийОграниченияПримененияЗаОбъемПродаж, ВалютаОграничения, ГрафикОплаты, ФормаОплаты,
	                      |ЗначениеУсловияОграничения, СегментНоменклатурыОграничения, ПериодНакопления,
	                      |ТипСравнения, ГруппаПользователей, ВидКартыЛояльности, 
	                      |СегментПартнеров, КоличествоПериодовНакопления, ВремяДействия,
	                      |КоличествоДнейДоДняРождения, КоличествоДнейПослеДняРождения, ВключатьТекущуюПродажуВНакопленныйОбъемПродаж,
	                      |ВариантОтбораНоменклатуры";
	
	Если Объект.УсловиеПредоставления = ПредопределенноеЗначение("Перечисление.УсловияПредоставленияСкидокНаценок.ВхождениеПартнераВСегмент") Тогда
		
		СтрокаИспользуемыеРеквизиты = "СегментПартнеров";
		
	ИначеЕсли Объект.УсловиеПредоставления = ПредопределенноеЗначение("Перечисление.УсловияПредоставленияСкидокНаценок.ЗаВремяПродажи") Тогда
		
		СтрокаИспользуемыеРеквизиты = "ВремяДействия";
	
	ИначеЕсли Объект.УсловиеПредоставления = ПредопределенноеЗначение("Перечисление.УсловияПредоставленияСкидокНаценок.ЗаГрафикОплаты") Тогда
		
		СтрокаИспользуемыеРеквизиты = "ГрафикОплаты";
		
	ИначеЕсли Объект.УсловиеПредоставления = ПредопределенноеЗначение("Перечисление.УсловияПредоставленияСкидокНаценок.ЗаДеньРожденияКлиента") Тогда
		
		СтрокаИспользуемыеРеквизиты = "КоличествоДнейДоДняРождения,КоличествоДнейПослеДняРождения";
		
	ИначеЕсли ТипЗнч(Объект.УсловиеПредоставления) = Тип("СправочникСсылка.ДополнительныеОтчетыИОбработки") Тогда
		
		СтрокаИспользуемыеРеквизиты = "";
		
	ИначеЕсли Объект.УсловиеПредоставления = ПредопределенноеЗначение("Перечисление.УсловияПредоставленияСкидокНаценок.ЗаНакопленныйОбъемПродаж") Тогда
		
		СтрокаИспользуемыеРеквизиты = "ВариантОпределенияПериодаНакопительнойСкидки, ВариантНакопления, КритерийОграниченияПримененияЗаОбъемПродаж,
		                              |ВалютаОграничения,ТипСравнения,
		                              |ЗначениеУсловияОграничения, СегментНоменклатурыОграничения, ПериодНакопления,
		                              |ТипСравнения, СегментПартнеров, КоличествоПериодовНакопления, ВключатьТекущуюПродажуВНакопленныйОбъемПродаж";
		
	ИначеЕсли Объект.УсловиеПредоставления = ПредопределенноеЗначение("Перечисление.УсловияПредоставленияСкидокНаценок.ЗаНаличиеКартыЛояльности") Тогда
		
		СтрокаИспользуемыеРеквизиты = "ВидКартыЛояльности";
		
	ИначеЕсли Объект.УсловиеПредоставления = ПредопределенноеЗначение("Перечисление.УсловияПредоставленияСкидокНаценок.ЗаРазовыйОбъемПродаж") Тогда
		
		СтрокаИспользуемыеРеквизиты = "КритерийОграниченияПримененияЗаОбъемПродаж,
		                             |ВалютаОграничения,ТипСравнения,
		                             |ЗначениеУсловияОграничения, СегментНоменклатурыОграничения,
		                             |ТипСравнения, СегментПартнеров";
		
	ИначеЕсли Объект.УсловиеПредоставления = ПредопределенноеЗначение("Перечисление.УсловияПредоставленияСкидокНаценок.ЗаФормуОплаты") Тогда
		
		СтрокаИспользуемыеРеквизиты = "ФормаОплаты";
		
	ИначеЕсли Объект.УсловиеПредоставления = ПредопределенноеЗначение("Перечисление.УсловияПредоставленияСкидокНаценок.КартаЛояльностиНеЗарегистрирована") Тогда
		
		СтрокаИспользуемыеРеквизиты = "ВидКартыЛояльности";
		
	ИначеЕсли Объект.УсловиеПредоставления = ПредопределенноеЗначение("Перечисление.УсловияПредоставленияСкидокНаценок.ОграничениеПоГруппеПользователей") Тогда
		
		СтрокаИспользуемыеРеквизиты = "ГруппаПользователей";
		
	КонецЕсли;
	
	ИспользуемыеРеквизиты = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаИспользуемыеРеквизиты, ",", Истина, Истина);
	ВсеРеквизиты = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаВсеРеквизиты, ",", Истина, Истина);
	
	Для Каждого ЭлементМассива Из ИспользуемыеРеквизиты Цикл
	
		ПорядковыйНомер = ВсеРеквизиты.Найти(ЭлементМассива);
		Если ПорядковыйНомер <> Неопределено Тогда
			ВсеРеквизиты.Удалить(ПорядковыйНомер);
		КонецЕсли;
	
	КонецЦикла;
	
	Для каждого РеквизитКОчистке Из ВсеРеквизиты Цикл
	
		Если РеквизитКОчистке = "ВариантОпределенияПериодаНакопительнойСкидки" Тогда
			
			Объект.ВариантОпределенияПериодаНакопительнойСкидки = ПредопределенноеЗначение("Перечисление.ВариантыОпределенияПериодаНакопительнойСкидки.ПустаяСсылка");
			
		ИначеЕсли РеквизитКОчистке = "ВариантНакопления" Тогда
			
			Объект.ВариантНакопления = ПредопределенноеЗначение("Перечисление.ВариантыНакопленияКумулятивнойСкидкиНаценки.ПустаяСсылка");
			
		ИначеЕсли РеквизитКОчистке = "КритерийОграниченияПримененияЗаОбъемПродаж" Тогда
			
			Объект.КритерийОграниченияПримененияЗаОбъемПродаж = ПредопределенноеЗначение("Перечисление.КритерииОграниченияПримененияСкидкиНаценкиЗаОбъемПродаж.ПустаяСсылка");
			
		ИначеЕсли РеквизитКОчистке = "ВалютаОграничения" Тогда
			
			Объект.ВалютаОграничения = ПредопределенноеЗначение("Справочник.Валюты.ПустаяСсылка");
			
		ИначеЕсли РеквизитКОчистке = "ГрафикОплаты" Тогда
			
			Объект.ГрафикОплаты = ПредопределенноеЗначение("Справочник.ГрафикиОплаты.ПустаяСсылка");
			
		ИначеЕсли РеквизитКОчистке = "ФормаОплаты" Тогда
			
			Объект.ФормаОплаты = ПредопределенноеЗначение("Перечисление.ФормыОплаты.ПустаяСсылка");
			
		ИначеЕсли РеквизитКОчистке = "ЗначениеУсловияОграничения" Тогда
			
			Объект.ЗначениеУсловияОграничения = 0;
			
		ИначеЕсли РеквизитКОчистке = "СегментНоменклатурыОграничения" Тогда
			
			Объект.СегментНоменклатурыОграничения = ПредопределенноеЗначение("Справочник.СегментыНоменклатуры.ПустаяСсылка");
			
		ИначеЕсли РеквизитКОчистке = "ПериодНакопления" Тогда
			
			Объект.ПериодНакопления = ПредопределенноеЗначение("Перечисление.Периодичность.ПустаяСсылка");
			
		ИначеЕсли РеквизитКОчистке = "ТипСравнения" Тогда
			
			Объект.ТипСравнения = ПредопределенноеЗначение("Перечисление.ТипыСравненияЗначенийСкидокНаценок.ПустаяСсылка");
			
		ИначеЕсли РеквизитКОчистке = "ГруппаПользователей" Тогда
			
			Объект.ГруппаПользователей = ПредопределенноеЗначение("Справочник.ГруппыПользователей.ПустаяСсылка");
			
		ИначеЕсли РеквизитКОчистке = "ВидКартыЛояльности" Тогда
			
			Объект.ВидКартыЛояльности = ПредопределенноеЗначение("Справочник.ВидыКартЛояльности.ПустаяСсылка");
			
		ИначеЕсли РеквизитКОчистке = "СегментПартнеров" Тогда
			
			Объект.СегментПартнеров = ПредопределенноеЗначение("Справочник.СегментыПартнеров.ПустаяСсылка");
			
		ИначеЕсли РеквизитКОчистке = "КоличествоПериодовНакопления" Тогда
			
			Объект.КоличествоПериодовНакопления = 0;
			
		ИначеЕсли РеквизитКОчистке = "ВремяДействия" Тогда
			
			Объект.ВремяДействия.Очистить();
			
		КонецЕсли;
	
	КонецЦикла;

КонецПроцедуры

// Автонаименование условия предоставления скидки
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Изменяемая форма, должна содержать в том числе:
//  	* Элементы - ЭлементыФормы:
//  		** Наименование - ПолеФормы
// 
// Возвращаемое значение:
//  Строка - Наименование
//
Функция АвтоНаименованиеУсловияПредоставленияСкидки(Форма) Экспорт
	
	Форма.Элементы["Наименование"].СписокВыбора.Очистить();
	
	Объект = Форма.Объект;
	
	ПоКакойНоменклатуре = "";
	Если Объект.ВариантОтбораНоменклатуры = ПредопределенноеЗначение("Перечисление.ВариантыОтбораНоменклатурыДляРасчетаСкидокНаценок.СписокНоменклатуры") Тогда
		Если Строка(Форма.СписокНоменклатурныхПозиций) <> НСтр("ru = 'Добавить'") Тогда
			ПоКакойНоменклатуре = СтрШаблон(НСтр("ru = 'по номенклатуре из списка: %1'"), Форма.СписокНоменклатурныхПозиций);
		КонецЕсли
	ИначеЕсли Объект.ВариантОтбораНоменклатуры = ПредопределенноеЗначение("Перечисление.ВариантыОтбораНоменклатурыДляРасчетаСкидокНаценок.СегментНоменклатуры") Тогда
		ПоКакойНоменклатуре = СтрШаблон(НСтр("ru = 'по номенклатуре из сегмента %1'"), Объект.СегментНоменклатурыОграничения);
	ИначеЕсли Объект.ВариантОтбораНоменклатуры = ПредопределенноеЗначение("Перечисление.ВариантыОтбораНоменклатурыДляРасчетаСкидокНаценок.НеСегментНоменклатуры") Тогда
		ПоКакойНоменклатуре = СтрШаблон(НСтр("ru = 'по номенклатуре не из сегмента %1'"), Объект.СегментНоменклатурыОграничения);
	ИначеЕсли Объект.ВариантОтбораНоменклатуры = ПредопределенноеЗначение("Перечисление.ВариантыОтбораНоменклатурыДляРасчетаСкидокНаценок.ОтборКомпоновкиДанных") Тогда
		ПоКакойНоменклатуре = НСтр("ru = 'по отобранной номенклатуре'");
	КонецЕсли;
	
	Если Объект.УсловиеПредоставления = ПредопределенноеЗначение("Перечисление.УсловияПредоставленияСкидокНаценок.ЗаВремяПродажи") Тогда
		СтрокаНаименования = НСтр("ru = 'Время продажи:'");
		ПервыйДень = Истина;
		Для Каждого СтрокаТаблицы Из Объект.ВремяДействия Цикл
			СтрокаНаименования = СтрокаНаименования + 
			                     ?(ПервыйДень," ", ", ")+ СтрокаТаблицы.ДеньНедели + 
			                     СтрШаблон(НСтр("ru = '(с %1 до %2)'"), Формат(СтрокаТаблицы.ВремяНачала,"ДФ=ЧЧ:мм"), Формат(СтрокаТаблицы.ВремяОкончания,"ДФ=ЧЧ:мм"));
			ПервыйДень = Ложь;
		КонецЦикла;
	ИначеЕсли Объект.УсловиеПредоставления = ПредопределенноеЗначение("Перечисление.УсловияПредоставленияСкидокНаценок.ЗаФормуОплаты") Тогда
		СтрокаНаименования = СтрШаблон(НСтр("ru = 'Форма оплаты: %1'"), Объект.ФормаОплаты);
	ИначеЕсли Объект.УсловиеПредоставления = ПредопределенноеЗначение("Перечисление.УсловияПредоставленияСкидокНаценок.ЗаДеньРожденияКлиента") Тогда
		СтрокаНаименования = НСтр("ru = 'День рождения клиента'");
	ИначеЕсли Объект.УсловиеПредоставления = ПредопределенноеЗначение("Перечисление.УсловияПредоставленияСкидокНаценок.ВхождениеПартнераВСегмент") Тогда
		СтрокаНаименования = СтрШаблон(НСтр("ru = 'Клиент входит в сегмент: %1'"), Объект.СегментПартнеров);
	ИначеЕсли Объект.УсловиеПредоставления = ПредопределенноеЗначение("Перечисление.УсловияПредоставленияСкидокНаценок.ЗаГрафикОплаты") Тогда
		СтрокаНаименования = СтрШаблон(НСтр("ru = 'График оплаты: %1'"), Объект.ГрафикОплаты);
	ИначеЕсли Объект.УсловиеПредоставления = ПредопределенноеЗначение("Перечисление.УсловияПредоставленияСкидокНаценок.КартаЛояльностиНеЗарегистрирована") Тогда
		СтрокаНаименования = СтрШаблон(НСтр("ru = 'Карта лояльности ""%1"" не зарегистрирована'"), Объект.ВидКартыЛояльности);
	ИначеЕсли Объект.УсловиеПредоставления = ПредопределенноеЗначение("Перечисление.УсловияПредоставленияСкидокНаценок.ЗаНаличиеКартыЛояльности") Тогда
		СтрокаНаименования = СтрШаблон(НСтр("ru = 'Клиент владелец карты лояльности ""%1""'"), Объект.ВидКартыЛояльности);
	ИначеЕсли Объект.УсловиеПредоставления = ПредопределенноеЗначение("Перечисление.УсловияПредоставленияСкидокНаценок.ОграничениеПоГруппеПользователей") Тогда
		СтрокаНаименования = СтрШаблон(НСтр("ru = 'Группа пользователей: %1'"), Объект.ГруппаПользователей);
	ИначеЕсли Объект.УсловиеПредоставления = ПредопределенноеЗначение("Перечисление.УсловияПредоставленияСкидокНаценок.ЗаРазовыйОбъемПродаж") Тогда
		
		Если Объект.КритерийОграниченияПримененияЗаОбъемПродаж = ПредопределенноеЗначение("Перечисление.КритерииОграниченияПримененияСкидкиНаценкиЗаОбъемПродаж.Количество") Тогда
			СтрокаНаименования = СтрШаблон(
				НСтр("ru = 'Количество в документе %1 %2 ед. %3'"),
				Объект.ТипСравнения,
				Объект.ЗначениеУсловияОграничения,
				ПоКакойНоменклатуре);
		ИначеЕсли Объект.КритерийОграниченияПримененияЗаОбъемПродаж = ПредопределенноеЗначение("Перечисление.КритерииОграниченияПримененияСкидкиНаценкиЗаОбъемПродаж.КоличествоРазличных") Тогда
			СтрокаНаименования = СтрШаблон(
				НСтр("ru = 'Количество различных наименований в документе %1 %2 шт. %3'"),
				Объект.ТипСравнения,
				Объект.ЗначениеУсловияОграничения,
				ПоКакойНоменклатуре);
		ИначеЕсли Объект.КритерийОграниченияПримененияЗаОбъемПродаж = ПредопределенноеЗначение("Перечисление.КритерииОграниченияПримененияСкидкиНаценкиЗаОбъемПродаж.КоличествоОдинаковых") Тогда
			СтрокаНаименования = СтрШаблон(
				НСтр("ru = 'Количество одинаковых позиций в документе %1 %2 ед. %3'"),
				Объект.ТипСравнения,
				Объект.ЗначениеУсловияОграничения,
				ПоКакойНоменклатуре);
		ИначеЕсли Объект.КритерийОграниченияПримененияЗаОбъемПродаж = ПредопределенноеЗначение("Перечисление.КритерииОграниченияПримененияСкидкиНаценкиЗаОбъемПродаж.Сумма") Тогда
			СтрокаНаименования = СтрШаблон(
				НСтр("ru = 'Сумма в документе %1 %2 %3 %4'"),
				Объект.ТипСравнения,
				Объект.ЗначениеУсловияОграничения,
				Объект.ВалютаОграничения,
				ПоКакойНоменклатуре);
		КонецЕсли;
		
	ИначеЕсли Объект.УсловиеПредоставления = ПредопределенноеЗначение("Перечисление.УсловияПредоставленияСкидокНаценок.ЗаНакопленныйОбъемПродаж") Тогда
	
		Если Объект.ВариантОпределенияПериодаНакопительнойСкидки = ПредопределенноеЗначение("Перечисление.ВариантыОпределенияПериодаНакопительнойСкидки.ВесьПериод") Тогда
			
			Период = НСтр("ru = 'за весь период'");
			
		ИначеЕсли Объект.ВариантОпределенияПериодаНакопительнойСкидки = ПредопределенноеЗначение("Перечисление.ВариантыОпределенияПериодаНакопительнойСкидки.ПрошлыйПериод") Тогда
			
			Строка = "";
			Если Объект.ПериодНакопления = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
				Строка = НСтр("ru = 'прошлый год,прошлых года,прошлых лет'");
			ИначеЕсли Объект.ПериодНакопления = ПредопределенноеЗначение("Перечисление.Периодичность.Декада") Тогда
				Строка = НСтр("ru = 'прошлую декаду,прошлых декады,прошлых декад'");
			ИначеЕсли Объект.ПериодНакопления = ПредопределенноеЗначение("Перечисление.Периодичность.День") Тогда
				Строка = НСтр("ru = 'прошлый день,прошлых дня,прошлых дней'");
			ИначеЕсли Объект.ПериодНакопления = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
				Строка = НСтр("ru = 'прошлый квартал,прошлых квартала,прошлых кварталов'");
			ИначеЕсли Объект.ПериодНакопления = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
				Строка = НСтр("ru = 'прошлый месяц,прошлых месяца,прошлых месяцев'");
			ИначеЕсли Объект.ПериодНакопления = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя") Тогда
				Строка = НСтр("ru = 'прошлую неделю,прошлых недели,прошлых недель'");
			ИначеЕсли Объект.ПериодНакопления = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
				Строка = НСтр("ru = 'прошлое полугодие,прошлых полугодия,прошлых полугодий'");
			КонецЕсли;
			
			Период = СтрШаблон(НСтр("ru='за %1'"), СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(Объект.КоличествоПериодовНакопления, Строка));
			
		ИначеЕсли Объект.ВариантОпределенияПериодаНакопительнойСкидки = ПредопределенноеЗначение("Перечисление.ВариантыОпределенияПериодаНакопительнойСкидки.СНачалаТекущегоПериода") Тогда
			
			Если Объект.ПериодНакопления = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
				Период = НСтр("ru = 'с начала текущего года'");
			ИначеЕсли Объект.ПериодНакопления = ПредопределенноеЗначение("Перечисление.Периодичность.Декада") Тогда
				Период = НСтр("ru = 'с начала текущей декады'");
			ИначеЕсли Объект.ПериодНакопления = ПредопределенноеЗначение("Перечисление.Периодичность.День") Тогда
				Период = НСтр("ru = 'с начала текущего дня'");
			ИначеЕсли Объект.ПериодНакопления = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
				Период = НСтр("ru = 'с начала текущего квартала'");
			ИначеЕсли Объект.ПериодНакопления = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
				Период = НСтр("ru = 'с начала текущего месяца'");
			ИначеЕсли Объект.ПериодНакопления = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя") Тогда
				Период = НСтр("ru = 'с начала текущей недели'");
			ИначеЕсли Объект.ПериодНакопления = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
				Период = НСтр("ru = 'с начала текущего полугодия'");
			КонецЕсли;
			
		ИначеЕсли Объект.ВариантОпределенияПериодаНакопительнойСкидки = ПредопределенноеЗначение("Перечисление.ВариантыОпределенияПериодаНакопительнойСкидки.ПрошлыйСкользящийПериод") Тогда
			
			Строка = "";
			Если Объект.ПериодНакопления = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
				Строка = НСтр("ru = 'предыдущий год,предыдущих года,предыдущих лет'");
			ИначеЕсли Объект.ПериодНакопления = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
				Строка = НСтр("ru = 'предыдущее полугодие,предыдущих полугодия,предыдущих полугодий'");
			ИначеЕсли Объект.ПериодНакопления = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
				Строка = НСтр("ru = 'предыдущий квартал,предыдущих квартала,предыдущих кварталов'");
			ИначеЕсли Объект.ПериодНакопления = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
				Строка = НСтр("ru = 'предыдущий месяц,предыдущих месяца,предыдущих месяцев'");
			ИначеЕсли Объект.ПериодНакопления = ПредопределенноеЗначение("Перечисление.Периодичность.Декада") Тогда
				Строка = НСтр("ru = 'предыдущую декаду,предыдущих декады,предыдущих декад'");
			ИначеЕсли Объект.ПериодНакопления = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя") Тогда
				Строка = НСтр("ru = 'предыдущую неделю,предыдущих недель,предыдущих недель'");
			ИначеЕсли Объект.ПериодНакопления = ПредопределенноеЗначение("Перечисление.Периодичность.День") Тогда
				Строка = НСтр("ru = 'предыдущий день,предыдущих дня,предыдущих дней'");
			КонецЕсли;
			
			Период = СтрШаблон(НСтр("ru='за %1'"), СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(Объект.КоличествоПериодовНакопления, Строка));
			
		КонецЕсли;
		
		ВариантНакопления = ?(Объект.ВариантНакопления = ПредопределенноеЗначение("Перечисление.ВариантыНакопленияКумулятивнойСкидкиНаценки.ПоПартнеру"), НСтр("ru = 'по клиенту'"), НСтр("ru = 'по торговому соглашению'"));
		
		Если Объект.КритерийОграниченияПримененияЗаОбъемПродаж = ПредопределенноеЗначение("Перечисление.КритерииОграниченияПримененияСкидкиНаценкиЗаОбъемПродаж.Количество") Тогда
			СтрокаНаименования = СтрШаблон(
				НСтр("ru = 'Количество проданной номенклатуры %4 %1 %2 ед. %3'"),
				Объект.ТипСравнения,
				Объект.ЗначениеУсловияОграничения,
				ПоКакойНоменклатуре,
				ВариантНакопления);
		ИначеЕсли Объект.КритерийОграниченияПримененияЗаОбъемПродаж = ПредопределенноеЗначение("Перечисление.КритерииОграниченияПримененияСкидкиНаценкиЗаОбъемПродаж.КоличествоРазличных") Тогда
			СтрокаНаименования = СтрШаблон(
				НСтр("ru = 'Количество различных наименований проданной номенклатуры %4 %1 %2 шт. %3'"),
				Объект.ТипСравнения,
				Объект.ЗначениеУсловияОграничения,
				ПоКакойНоменклатуре,
				ВариантНакопления);
		ИначеЕсли Объект.КритерийОграниченияПримененияЗаОбъемПродаж = ПредопределенноеЗначение("Перечисление.КритерииОграниченияПримененияСкидкиНаценкиЗаОбъемПродаж.КоличествоОдинаковых") Тогда
			СтрокаНаименования = СтрШаблон(
				НСтр("ru = 'Количество одинаковых позиций проданной номенклатуры %4 %1 %2 ед. %3'"),
				Объект.ТипСравнения,
				Объект.ЗначениеУсловияОграничения,
				ПоКакойНоменклатуре,
				ВариантНакопления);
		ИначеЕсли Объект.КритерийОграниченияПримененияЗаОбъемПродаж = ПредопределенноеЗначение("Перечисление.КритерииОграниченияПримененияСкидкиНаценкиЗаОбъемПродаж.Сумма") Тогда
			СтрокаНаименования = СтрШаблон(
				НСтр("ru = 'Сумма проданной номенклатуры %5 %1 %2 %3 %4'"),
				Объект.ТипСравнения,
				Объект.ЗначениеУсловияОграничения,
				Объект.ВалютаОграничения,
				ПоКакойНоменклатуре, 
				ВариантНакопления);
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Объект.УсловиеПредоставления) = Тип("СправочникСсылка.ДополнительныеОтчетыИОбработки") Тогда
		
		СтрокаНаименования = Форма.АвтонаименованиеВнешнейОбработки;
		
	КонецЕсли;

	ПолеФормыНаименование = Форма.Элементы.Наименование; // ПолеФормы
	
	ПолеФормыНаименование.СписокВыбора.Добавить(СтрокаНаименования);
	
	Если Форма.ИндексАвтонаименования <= ПолеФормыНаименование.СписокВыбора.Количество() - 1 Тогда
		Возврат ПолеФормыНаименование.СписокВыбора.Получить(Форма.ИндексАвтонаименования).Значение;
	Иначе
		Возврат СтрокаНаименования;
	КонецЕсли;

КонецФункции

// Обновить реквизиты автонаименования
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Изменяемая форма, должна содержать в том числе:
//  	* Элементы - ЭлементыФормы:
//  		** Наименование - ПолеФормы
//
Процедура ОбновитьРеквизитыАвтонаименования(Форма) Экспорт
	
	Форма.ИндексАвтонаименования = 0;
	Форма.НаименованиеИзмененоПользователем = Истина;
	Форма.ИспользуетсяАвтоНаименование = Ложь;
	ПолеФормыНаименование = Форма.Элементы.Наименование;
	ПолеФормыНаименованиеСписокВыбора = ПолеФормыНаименование.СписокВыбора; // СписокЗначений
	Для Каждого ЭлементСписка Из ПолеФормыНаименованиеСписокВыбора Цикл
		
		Если ЭлементСписка.Значение = ПолеФормыНаименование Тогда
			Форма.ИспользуетсяАвтоНаименование = Истина;
			Форма.НаименованиеИзмененоПользователем = Ложь;
			Форма.ИндексАвтонаименования = ПолеФормыНаименованиеСписокВыбора.Индекс(ЭлементСписка);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Настраивает текст гиперссылок на отбор номенклатуры.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - Изменяемая форма
Процедура НастроитьГиперссылкиОтборов(Форма) Экспорт
	
	Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(Форма, "КомпоновщикНастроекОтборПоНоменклатуре") Тогда
		НастроитьГиперссылкуОтбора(Форма, "КомпоновщикНастроекОтборПоНоменклатуре");
	КонецЕсли;
	
#Если Клиент Тогда
	ЦветГиперссылки = ОбщегоНазначенияКлиентПовтИсп.ЦветСтиля("ГиперссылкаЦвет");
#Иначе
	ЦветГиперссылки = ЦветаСтиля.ГиперссылкаЦвет;
#КонецЕсли
	
	Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(Форма, "КомпоновщикНастроекДополнительныеУсловия") Тогда
		НастроитьГиперссылкуОтбора(
			Форма,
			"КомпоновщикНастроекДополнительныеУсловия",
			ЦветГиперссылки,
			НСтр("ru = 'Без уточнений'"),
			НСтр("ru = 'По которой'"));
	КонецЕсли;
	
КонецПроцедуры

// Настраивает текст гиперссылок на список номенклатурных позиций.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - Изменяемая форма, содержит в том числе:
//		* Объект - ДокументОбъект - Документ
Процедура НастроитьГиперссылкуНаСписокНоменклатурныхПозиций(Форма) Экспорт
	
	ВсегоПозиций = 0;
	КоличествоПервыхПозиций = 0;
	
	Если ЗначениеЗаполнено(Форма.Объект.Ссылка) Тогда
		ДанныеДляПредставленияСпискаТоваров = СкидкиНаценкиВызовСервера.ДанныеДляПредставленияСпискаТоваров(Форма.Объект.Ссылка);
		КоличествоПервыхПозиций = ДанныеДляПредставленияСпискаТоваров.ПервыеПозиции.Количество();
		ВсегоПозиций = ДанныеДляПредставленияСпискаТоваров.ВсегоПозиций;
	КонецЕсли;
	
	ПредставлениеСпискаТоваров = "";
	Если КоличествоПервыхПозиций > 0 Тогда
		ПредставлениеСпискаТоваров = СтрСоединить(ДанныеДляПредставленияСпискаТоваров.ПервыеПозиции, ", ");
	Иначе
		ПредставлениеСпискаТоваров = НСтр("ru = 'Добавить'");
	КонецЕсли;
	Если КоличествоПервыхПозиций < ВсегоПозиций Тогда
		ПредставлениеСпискаТоваров = ПредставлениеСпискаТоваров
		                           + " " + НСтр("ru = 'и еще'") + " "
		                           + СтроковыеФункцииКлиентСервер.ЧислоЦифрамиПредметИсчисленияПрописью(ВсегоПозиций - КоличествоПервыхПозиций, НСтр("ru = 'позиция,позиции,позиций'"));
	КонецЕсли;
	
#Если Клиент Тогда
	ЦветГиперссылки = ОбщегоНазначенияКлиентПовтИсп.ЦветСтиля("ГиперссылкаЦвет");
#Иначе
	ЦветГиперссылки = ЦветаСтиля.ГиперссылкаЦвет;
#КонецЕсли
	
	Форма.СписокНоменклатурныхПозиций = Новый ФорматированнаяСтрока(
		ПредставлениеСпискаТоваров,
		Новый Шрифт(,, Ложь,,,Ложь),
		ЦветГиперссылки,,"Изменить");
	
КонецПроцедуры

// Обработчик события при изменении у поля Вариант определения периода накопительной скидки.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - Изменяемая форма
//
Процедура ВариантОпределенияПериодаНакопительнойСкидкиПриИзмененииНаСервере(Форма) Экспорт
	
	Если Форма.Объект.ВариантОпределенияПериодаНакопительнойСкидки = ПредопределенноеЗначение("Перечисление.ВариантыОпределенияПериодаНакопительнойСкидки.ВесьПериод") Тогда
		Форма.Элементы.ПериодНакопления.Видимость = Ложь;
		Форма.Элементы.ДекорацияРавный.Видимость = Ложь;
		Форма.Элементы.КоличествоПериодовНакопления.Видимость = Ложь;
	ИначеЕсли Форма.Объект.ВариантОпределенияПериодаНакопительнойСкидки = ПредопределенноеЗначение("Перечисление.ВариантыОпределенияПериодаНакопительнойСкидки.СНачалаТекущегоПериода") Тогда
		Форма.Элементы.ПериодНакопления.Видимость = Истина;
		Форма.Элементы.ДекорацияРавный.Видимость = Истина;
		Форма.Элементы.КоличествоПериодовНакопления.Видимость = Ложь;
		Форма.Объект.КоличествоПериодовНакопления = 1;
	Иначе
		Форма.Элементы.ПериодНакопления.Видимость = Истина;
		Форма.Элементы.ДекорацияРавный.Видимость = Истина;
		Форма.Элементы.КоличествоПериодовНакопления.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события при изменении у поля Критерий применения за объем продаж
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - Изменяемая форма
//
Процедура КритерийПримененияЗаОбъемПродажПриИзмененииНаСервере(Форма) Экспорт
	
	КоличествоРазличных = ПредопределенноеЗначение("Перечисление.КритерииОграниченияПримененияСкидкиНаценкиЗаОбъемПродаж.КоличествоРазличных");
	КоличествоОдинаковых = ПредопределенноеЗначение("Перечисление.КритерииОграниченияПримененияСкидкиНаценкиЗаОбъемПродаж.КоличествоОдинаковых");
	Количество = ПредопределенноеЗначение("Перечисление.КритерииОграниченияПримененияСкидкиНаценкиЗаОбъемПродаж.Количество");
	
	Форма.Элементы.УчитыватьХарактеристики.Видимость = (Форма.Объект.КритерийОграниченияПримененияЗаОбъемПродаж = КоличествоРазличных
		ИЛИ Форма.Объект.КритерийОграниченияПримененияЗаОбъемПродаж = КоличествоОдинаковых);
	Форма.Элементы.УчитыватьХарактеристикиЗаНакопленныйОбъемПродаж.Видимость = (Форма.Объект.КритерийОграниченияПримененияЗаОбъемПродаж = КоличествоРазличных
		ИЛИ Форма.Объект.КритерийОграниченияПримененияЗаОбъемПродаж = КоличествоОдинаковых);
	
	Если Форма.Объект.КритерийОграниченияПримененияЗаОбъемПродаж = Количество
	ИЛИ Форма.Объект.КритерийОграниченияПримененияЗаОбъемПродаж = КоличествоОдинаковых
	ИЛИ Форма.Объект.КритерийОграниченияПримененияЗаОбъемПродаж = КоличествоРазличных Тогда
		
		Форма.Элементы.ВалютаОграничения.Видимость = Ложь;
		Форма.Элементы.ВалютаОграниченияЗаНакопленныйОбъемПродаж.Видимость = Ложь;
		Форма.Элементы.ВалютаОграниченияНеИспользоватьНесколькоВалютЗаНакопленныйОбъемПродаж.Видимость = Ложь;
		Форма.Элементы.ВалютаОграниченияНеИспользоватьНесколькоВалют.Видимость = Ложь;
		
	Иначе
		
		Форма.Элементы.ВалютаОграничения.Видимость = Истина;
		Форма.Элементы.ВалютаОграниченияЗаНакопленныйОбъемПродаж.Видимость = Истина;
		Форма.Элементы.ВалютаОграниченияНеИспользоватьНесколькоВалютЗаНакопленныйОбъемПродаж.Видимость = Истина;
		Форма.Элементы.ВалютаОграниченияНеИспользоватьНесколькоВалют.Видимость = Истина;
		
	КонецЕсли;
	
	Форма.Элементы.ДекорацияПозицийВДокументе.Видимость = (Форма.Объект.КритерийОграниченияПримененияЗаОбъемПродаж = КоличествоРазличных
		ИЛИ Форма.Объект.КритерийОграниченияПримененияЗаОбъемПродаж = КоличествоОдинаковых);
	Форма.Элементы.ДекорацияВДокументе.Видимость = Не (Форма.Объект.КритерийОграниченияПримененияЗаОбъемПродаж = КоличествоРазличных
		ИЛИ Форма.Объект.КритерийОграниченияПримененияЗаОбъемПродаж = КоличествоОдинаковых);
	
	Форма.Элементы.ДекорацияПозицийПроданногоТовара.Видимость = (Форма.Объект.КритерийОграниченияПримененияЗаОбъемПродаж = КоличествоРазличных
		ИЛИ Форма.Объект.КритерийОграниченияПримененияЗаОбъемПродаж = КоличествоОдинаковых);
	Форма.Элементы.ДекорацияПроданногоТовара.Видимость = Не (Форма.Объект.КритерийОграниченияПримененияЗаОбъемПродаж = КоличествоРазличных
		ИЛИ Форма.Объект.КритерийОграниченияПримененияЗаОбъемПродаж = КоличествоОдинаковых);
	
КонецПроцедуры

// Обработчик события при изменении у поля Условие предоставления
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - Изменяемая форма
//
Процедура УсловиеПредоставленияПриИзмененииНаСервере(Форма) Экспорт
	
	Форма.Элементы.ЗаРазовыйОбъемПродаж.Видимость              = (Форма.Объект.УсловиеПредоставления = ПредопределенноеЗначение("Перечисление.УсловияПредоставленияСкидокНаценок.ЗаРазовыйОбъемПродаж"));
	Форма.Элементы.ЗаНакопленныйОбъемПродаж.Видимость          = (Форма.Объект.УсловиеПредоставления = ПредопределенноеЗначение("Перечисление.УсловияПредоставленияСкидокНаценок.ЗаНакопленныйОбъемПродаж"));
	Форма.Элементы.ЗаГрафикОплаты.Видимость                    = (Форма.Объект.УсловиеПредоставления = ПредопределенноеЗначение("Перечисление.УсловияПредоставленияСкидокНаценок.ЗаГрафикОплаты"));
	Форма.Элементы.ЗаПробнуюПродажу.Видимость                  = (Форма.Объект.УсловиеПредоставления = ПредопределенноеЗначение("Перечисление.УсловияПредоставленияСкидокНаценок.ЗаПробнуюПродажу"));
	Форма.Элементы.ЗаВремяДействия.Видимость                   = (Форма.Объект.УсловиеПредоставления = ПредопределенноеЗначение("Перечисление.УсловияПредоставленияСкидокНаценок.ЗаВремяПродажи"));
	Форма.Элементы.ЗаПервуюПродажуПартнеру.Видимость           = (Форма.Объект.УсловиеПредоставления = ПредопределенноеЗначение("Перечисление.УсловияПредоставленияСкидокНаценок.ЗаПервуюПродажуПартнеру"));
	Форма.Элементы.ЗаФормуОплаты.Видимость                     = (Форма.Объект.УсловиеПредоставления = ПредопределенноеЗначение("Перечисление.УсловияПредоставленияСкидокНаценок.ЗаФормуОплаты"));
	Форма.Элементы.ОграничениеПоГруппеПользователей.Видимость  = (Форма.Объект.УсловиеПредоставления = ПредопределенноеЗначение("Перечисление.УсловияПредоставленияСкидокНаценок.ОграничениеПоГруппеПользователей"));
	Форма.Элементы.КартаЛояльностиНеЗарегистрирована.Видимость = (Форма.Объект.УсловиеПредоставления = ПредопределенноеЗначение("Перечисление.УсловияПредоставленияСкидокНаценок.КартаЛояльностиНеЗарегистрирована"));
	Форма.Элементы.ЗаНаличиеКартыЛояльности.Видимость          = (Форма.Объект.УсловиеПредоставления = ПредопределенноеЗначение("Перечисление.УсловияПредоставленияСкидокНаценок.ЗаНаличиеКартыЛояльности"));
	Форма.Элементы.ВхождениеПартнераВСегмент.Видимость         = (Форма.Объект.УсловиеПредоставления = ПредопределенноеЗначение("Перечисление.УсловияПредоставленияСкидокНаценок.ВхождениеПартнераВСегмент"));
	Форма.Элементы.ЗаДеньРожденияПартнера.Видимость            = (Форма.Объект.УсловиеПредоставления = ПредопределенноеЗначение("Перечисление.УсловияПредоставленияСкидокНаценок.ЗаДеньРожденияКлиента"));
	Форма.Элементы.ВнешняяОбработка.Видимость                  = (ТипЗнч(Форма.Объект.УсловиеПредоставления) = Тип("СправочникСсылка.ДополнительныеОтчетыИОбработки"));
	
	Если ТипЗнч(Форма.Объект.УсловиеПредоставления) = Тип("СправочникСсылка.ДополнительныеОтчетыИОбработки") Тогда
		
		ОписаниеВнешнейОбработки = СкидкиНаценкиВызовСервера.ОписаниеВнешнейОбработки(
				Форма.Объект.УсловиеПредоставления,
				Форма.АдресНастроекВнешнейОбработки);
		
		Форма.ОписаниеДействияВнешнейОбработки = ОписаниеВнешнейОбработки.ОписаниеДействия;
		Форма.АвтонаименованиеВнешнейОбработки = ОписаниеВнешнейОбработки.Автонаименование;
		Форма.ИмяФормыНастроекВнешнейОбработки = ОписаниеВнешнейОбработки.ИмяФормыНастроек;
		Форма.Элементы.ПоказатьФормуНастроекВнешнейОбработки.Видимость = ЗначениеЗаполнено(Форма.ИмяФормыНастроекВнешнейОбработки);
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Представление поля отбора
//
// Параметры:
//  Поле - ПолеКомпоновкиДанных - Поле
//  Отрицание - Булево - Признак наличия отрицания
//  НРег - Булево - Признак использования нижнего регистра.
// 
// Возвращаемое значение:
//  Строка - Представление поля отбора.
//
Функция ПредставлениеПоляОтбора(Поле, Отрицание = Ложь, НРег = Ложь)
	
	Если Строка(Поле) = "ВидЦены" Тогда
		ВозвращаемоеЗначение = НСтр("ru = 'Вид цены'");
	ИначеЕсли Строка(Поле) = "СегментНоменклатуры" Тогда
		ВозвращаемоеЗначение = НСтр("ru = 'Номенклатура входит в сегмент'");
	ИначеЕсли Строка(Поле) = "НеСегментНоменклатуры" Тогда
		ВозвращаемоеЗначение = НСтр("ru = 'Номенклатура не входит в сегмент'");
	ИначеЕсли Строка(Поле) = "КлиентПокупаетТоварВПервыйРаз" Тогда
		
		Если Отрицание Тогда
			ВозвращаемоеЗначение = НСтр("ru = 'Клиент покупает товар не в первый раз'");
		Иначе
			ВозвращаемоеЗначение = НСтр("ru = 'Клиент покупает товар в первый раз'");
		КонецЕсли;
		
	ИначеЕсли Строка(Поле) = "КоличествоБезУчетаХарактеристик" Тогда
		
		ВозвращаемоеЗначение = НСтр("ru = 'Количество одинаковых'");
		
	ИначеЕсли Строка(Поле) = "СуммаБезУчетаХарактеристик" Тогда
		
		ВозвращаемоеЗначение = НСтр("ru = 'Сумма по одинаковым'");
		
	ИначеЕсли Строка(Поле) = "Количество" Тогда
		
		ВозвращаемоеЗначение = НСтр("ru = 'Количество одинаковых (с учетом характеристик)'");
		
	ИначеЕсли Строка(Поле) = "Сумма" Тогда
		
		ВозвращаемоеЗначение = НСтр("ru = 'Сумма по одинаковым (с учетом характеристик)'");
		
	ИначеЕсли Строка(Поле) = "ЗаданаПроизвольнаяЦена" Тогда
		
		Если Отрицание Тогда
			ВозвращаемоеЗначение = НСтр("ru = 'Не задана произвольная цена'");
		Иначе
			ВозвращаемоеЗначение = НСтр("ru = 'Задана произвольная цена'");
		КонецЕсли;
		
	ИначеЕсли Строка(Поле) = "ДоступностьТовараДляКлиента" Тогда
		
		ВозвращаемоеЗначение = НСтр("ru = 'Доступность товара для клиента'");
		
	ИначеЕсли Строка(Поле) = "ЦенаСовпадаетСЦенойСоглашения" Тогда
		
		Если Отрицание Тогда
			ВозвращаемоеЗначение = НСтр("ru = 'Цена не совпадает с уточненной ценой из соглашения'");
		Иначе
			ВозвращаемоеЗначение = НСтр("ru = 'Цена совпадает с уточненной ценой из соглашения'");
		КонецЕсли;
		
	Иначе
		ВозвращаемоеЗначение = Строка(Поле);
	КонецЕсли;
	
	Если НРег Тогда
		ВозвращаемоеЗначение = НРег(ВозвращаемоеЗначение);
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Процедура - Настроить гиперссылку отбора
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Изменяемая форма
//  Имя - Строка - Имя элемента настроек отбора
//  ЦветОтборНеУстановлен - Цвет - Цвет отбор не установлен
//  ТекстОтборНеУстановлен - Строка - Текст отбор не установлен
//  Префикс - Строка - Префикс.
//
Процедура НастроитьГиперссылкуОтбора(Форма, Имя, Знач ЦветОтборНеУстановлен = Неопределено, Знач ТекстОтборНеУстановлен = Неопределено, Знач Префикс = "")
	
	НРег = ЗначениеЗаполнено(Префикс);
	
#Если Клиент Тогда
	ЦветГиперссылки = ОбщегоНазначенияКлиентПовтИсп.ЦветСтиля("ГиперссылкаЦвет");
#Иначе
	ЦветГиперссылки = ЦветаСтиля.ГиперссылкаЦвет;
#КонецЕсли

#Если Клиент Тогда
	ПоясняющийОшибкуТекст = ОбщегоНазначенияКлиентПовтИсп.ЦветСтиля("ПоясняющийОшибкуТекст");
#Иначе
	ПоясняющийОшибкуТекст = ЦветаСтиля.ПоясняющийОшибкуТекст;
#КонецЕсли
	
	НастройкиКомпоновкиДанных = Форма[Имя].Настройки; // НастройкиКомпоновкиДанных
	ПредставлениеОтбора = ПредставлениеОтбора(НастройкиКомпоновкиДанных.Отбор.Элементы, НРег);
	
	Если ЦветОтборНеУстановлен = Неопределено Тогда
		Если Форма.Объект.ВариантОтбораНоменклатуры = ПредопределенноеЗначение("Перечисление.ВариантыОтбораНоменклатурыДляРасчетаСкидокНаценок.ОтборКомпоновкиДанных") Тогда
			ЦветОтборНеУстановлен = ПоясняющийОшибкуТекст;
		Иначе
			ЦветОтборНеУстановлен = ЦветГиперссылки;
		КонецЕсли;
	КонецЕсли;
	Если ТекстОтборНеУстановлен = Неопределено Тогда
		ТекстОтборНеУстановлен = НСтр("ru = 'Отбор не установлен'");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПредставлениеОтбора) И Префикс <> "" Тогда
		ПредставлениеОтбора = Префикс + " " + ПредставлениеОтбора;
	КонецЕсли;
	
	Если Имя = "КомпоновщикНастроекОтборПоНоменклатуре" Тогда
		ИмяПредставления = "КомпоновщикНастроекОтборПоНоменклатуреПредставление";
	ИначеЕсли Имя = "КомпоновщикНастроекДополнительныеУсловия" Тогда 
		ИмяПредставления = "КомпоновщикНастроекДополнительныеУсловияПредставление";
	Иначе
		ИмяПредставления = "";
	КонецЕсли;
	
	Если Не ПустаяСтрока(ИмяПредставления) Тогда
		Если ЗначениеЗаполнено(ПредставлениеОтбора) Тогда
			Форма[ИмяПредставления] = Новый ФорматированнаяСтрока(
				ПредставлениеОтбора,
				Новый Шрифт(,, Ложь,,,Ложь),
				ЦветГиперссылки,,Имя);
		Иначе
			Форма[ИмяПредставления] = Новый ФорматированнаяСтрока(
				ТекстОтборНеУстановлен,
				Новый Шрифт(,, Ложь,,,Ложь),
				ЦветОтборНеУстановлен,,Имя);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Представление отбора
//
// Параметры:
//  ЭлементыОтбора - КоллекцияЭлементовОтбораКомпоновкиДанных - Элемент отбора
//  НРег - Булево - Признак использования нижнего регистра
//  РазделительЭлементов - Строка - Разделитель.
// 
// Возвращаемое значение:
//  Строка - Представление отбора.
//
Функция ПредставлениеОтбора(ЭлементыОтбора, НРег, РазделительЭлементов = ", ")
	
	ПредставлениеОтбора = "";
	
	Для Каждого ЭлементОтбора Из ЭлементыОтбора Цикл
		
		Если ПредставлениеОтбора = "" Тогда
			Разделитель = "";
		Иначе
			Разделитель = РазделительЭлементов;
		КонецЕсли;
		
		Если ЭлементОтбора.Использование Тогда
			Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
				Если (ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно ИЛИ ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно)
					И ТипЗнч(ЭлементОтбора.ПравоеЗначение) = Тип("Булево") Тогда
					
					Если ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда
						
						Если ЭлементОтбора.ПравоеЗначение = Истина Тогда
							СтрокаОтбора = СтрШаблон(
								НСтр("ru = '%1'"), ПредставлениеПоляОтбора(ЭлементОтбора.ЛевоеЗначение, Ложь, НРег));
						Иначе
							СтрокаОтбора = СтрШаблон(
								НСтр("ru = '%1'"), ПредставлениеПоляОтбора(ЭлементОтбора.ЛевоеЗначение, Истина, НРег));
						КонецЕсли;
						
					Иначе
						
						Если ЭлементОтбора.ПравоеЗначение = Истина Тогда
							СтрокаОтбора = СтрШаблон(
								НСтр("ru = '%1'"), ПредставлениеПоляОтбора(ЭлементОтбора.ЛевоеЗначение, Истина, НРег));
						Иначе
							СтрокаОтбора = СтрШаблон(
								НСтр("ru = '%1'"), ПредставлениеПоляОтбора(ЭлементОтбора.ЛевоеЗначение, Ложь, НРег));
						КонецЕсли;
						
					КонецЕсли;
					
				Иначе
					
					СтрокаОтбора = СтрШаблон(
						НСтр("ru = '%1 %2 ""%3""'"),
						ПредставлениеПоляОтбора(ЭлементОтбора.ЛевоеЗначение, Ложь, НРег), НРег(ЭлементОтбора.ВидСравнения), ЭлементОтбора.ПравоеЗначение);
					
				КонецЕсли;
			Иначе
				
				Если ЭлементОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ Тогда
					СтрокаОтбора = "(" + ПредставлениеОтбора(ЭлементОтбора.Элементы, НРег) + ")";
				ИначеЕсли ЭлементОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли Тогда
					СтрокаОтбора = "(" + ПредставлениеОтбора(ЭлементОтбора.Элементы, НРег," " + НСтр("ru = 'Или'")) + " )";
				ИначеЕсли ЭлементОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаНе Тогда
					СтрокаОтбора = НСтр("ru = 'Не'") + " (" + ПредставлениеОтбора(ЭлементОтбора.Элементы, НРег) + ")";
				КонецЕсли;
				
			КонецЕсли;
			ПредставлениеОтбора = ПредставлениеОтбора
			                    + Разделитель
			                    + СтрокаОтбора;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ПредставлениеОтбора;
	
КонецФункции

#КонецОбласти