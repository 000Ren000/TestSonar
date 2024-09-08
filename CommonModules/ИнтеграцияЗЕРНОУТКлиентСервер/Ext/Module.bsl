﻿#Область ПрограммныйИнтерфейс

#Область ПогашениеСДИЗЗЕРНО

// Заполняет структуру команд для динамического формирования доступных для создания документов на основании.
// 
// Параметры:
// 	Команды - Структура - Исходящий, структура команд динамически формируемых для создания документов на основании.
//
Процедура КомандыПогашенияСДИЗ(Команды) Экспорт 
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды,"ПриобретениеТоваровУслуг",          НСтр("ru = 'Приобретение товаров и услуг'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды,"ВозвратТоваровОтКлиента",           НСтр("ru = 'Возврат товаров от клиента'"));
	ФункциональныеОпцииПриемки = "ИспользоватьОтветственноеХранениеВПроцессеЗакупки";
	
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды,"ВыкупПринятыхНаХранениеТоваров",    НСтр("ru = 'Выкуп принятых на хранение товаров'"),   ФункциональныеОпцииПриемки);
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды,"ПриемкаТоваровНаХранение",          НСтр("ru = 'Приемку товаров на хранение'"),          ФункциональныеОпцииПриемки);
	

	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ПриобретениеТоваровУслуг",          НСтр("ru = 'Приобретение товаров и услуг'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ВозвратТоваровОтКлиента",           НСтр("ru = 'Возврат товаров от клиента'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ПеремещениеТоваров",                НСтр("ru = 'Перемещение товаров'"),                  "ИспользоватьПеремещениеТоваров");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ПередачаТоваровМеждуОрганизациями", НСтр("ru = 'Передачу товаров между организациями'"), "ИспользоватьПередачиТоваровМеждуОрганизациями");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ВозвратТоваровМеждуОрганизациями",  НСтр("ru = 'Возврат товаров между организациями'"),  "ИспользоватьПередачиТоваровМеждуОрганизациями");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ВыкупПринятыхНаХранениеТоваров",    НСтр("ru = 'Выкуп принятых на хранение товаров'"),   ФункциональныеОпцииПриемки);
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ПриемкаТоваровНаХранение",          НСтр("ru = 'Приемку товаров на хранение'"),          ФункциональныеОпцииПриемки);
	

	
КонецПроцедуры

#КонецОбласти

#Область ОформлениеСДИЗЗЕРНО

// Заполняет структуру команд для динамического формирования доступных для создания документов на основании.
// 
// Параметры:
// 	Команды - Структура - Исходящий, структура команд динамически формируемых для создания документов на основании.
//
Процедура КомандыОформлениеСДИЗЗЕРНО(Команды) Экспорт 
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ФормированиеПартийЗЕРНО",           НСтр("ru = 'Формирование партий'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "РеализацияТоваровУслуг",            НСтр("ru = 'Реализацию товаров услуг'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ВозвратТоваровПоставщику",          НСтр("ru = 'Возврат товаров поставщику'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ОтгрузкаТоваровСХранения",          НСтр("ru = 'Отгрузку товаров с хранения'"),          "ИспользоватьОтветственноеХранениеВПроцессеЗакупки");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ПередачаТоваровХранителю",          НСтр("ru = 'Передачу товаров'"),                     "ИспользоватьПередачуНаОтветственноеХранениеСПравомПродажи,ИспользоватьКомиссиюПриПродажах" + ИнтеграцияИСУТКлиентСервер.ИмяФункицональнойОпцииИспользоватьПроизводствоНаСтороне25());
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ПередачаТоваровМеждуОрганизациями", НСтр("ru = 'Передачу товаров между организациями'"), "ИспользоватьПередачиТоваровМеждуОрганизациями");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ВозвратТоваровМеждуОрганизациями",  НСтр("ru = 'Возврат товаров между организациями'"),  "ИспользоватьПередачиТоваровМеждуОрганизациями");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ПеремещениеТоваров",                НСтр("ru = 'Перемещение товаров'"),                  "ИспользоватьПеремещениеТоваров");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ПоступлениеТоваровОтХранителя",     НСтр("ru = 'Поступление товаров от хранителя'"),     "ИспользоватьПередачуНаОтветственноеХранениеСПравомПродажи" + ИнтеграцияИСУТКлиентСервер.ИмяФункицональнойОпцииИспользоватьПроизводствоНаСтороне25());
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ВыкупТоваровХранителем",            НСтр("ru = 'Выкуп товаров хранителем'"),             "ИспользоватьПередачуНаОтветственноеХранениеСПравомПродажи" + ИнтеграцияИСУТКлиентСервер.ИмяФункицональнойОпцииИспользоватьПроизводствоНаСтороне25());
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды, "РеализацияТоваровУслуг",            НСтр("ru = 'Реализацию товаров услуг'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды, "ВозвратТоваровПоставщику",          НСтр("ru = 'Возврат товаров поставщику'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды, "ОтгрузкаТоваровСХранения",          НСтр("ru = 'Отгрузку товаров с хранения'"),          "ИспользоватьОтветственноеХранениеВПроцессеЗакупки");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды, "ПередачаТоваровХранителю",          НСтр("ru = 'Передачу товаров'"),                     "ИспользоватьПередачуНаОтветственноеХранениеСПравомПродажи,ИспользоватьКомиссиюПриПродажах" + ИнтеграцияИСУТКлиентСервер.ИмяФункицональнойОпцииИспользоватьПроизводствоНаСтороне25());
	
	
КонецПроцедуры

// Устанавливает видимость команд динамически формируемых для создания документов на основании.
// 
// Параметры:
// 	Форма   - ФормаКлиентскогоПриложения - Форма на которой находятся вызова команд.
// 	Команды - Структура - структура команд динамически формируемых для создания документов на основании.
//
Процедура УправлениеВидимостьюКомандОформлениеСДИЗЗЕРНО(Форма, Команды) Экспорт
	
	Объект          = Форма.Объект;
	ЭтоИмпорт       = (Объект.Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийЗЕРНО.ОформлениеСДИЗИмпорт"));
	ЭтоРФ           = (Объект.Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийЗЕРНО.ОформлениеСДИЗРФ"));
	ЭтоЭлеватор     = (Объект.Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийЗЕРНО.ОформлениеСДИЗЭлеватор"));
	
	ТолькоПеревозка       = (Объект.Перевозка И Не Объект.Приемка И Не Объект.Отгрузка И Не Объект.Реализация);
	ТолькоПриемкаОтгрузка = (Не Объект.Перевозка И Объект.Приемка И Объект.Отгрузка И Не Объект.Реализация);
	ТолькоОтгрузка        = (Не Объект.Перевозка И Не Объект.Приемка И Объект.Отгрузка И Не Объект.Реализация);
	
	Для Каждого КлючИЗначение Из Форма.НастройкиВыполненияПодключаемыхКомандИС.Команды Цикл
		
		Если КлючИЗначение.Значение.ИмяМетаданных = "ФормированиеПартийЗЕРНО" Тогда
			Форма.Элементы[КлючИЗначение.Ключ].Видимость = ЭтоИмпорт;
		ИначеЕсли КлючИЗначение.Значение.ИмяМетаданных = "РеализацияТоваровУслуг" Тогда
			Форма.Элементы[КлючИЗначение.Ключ].Видимость = Объект.Реализация;
		ИначеЕсли КлючИЗначение.Значение.ИмяМетаданных = "ВозвратТоваровПоставщику" Тогда
			Форма.Элементы[КлючИЗначение.Ключ].Видимость = Объект.Реализация;
		ИначеЕсли КлючИЗначение.Значение.ИмяМетаданных = "ОтгрузкаТоваровСХранения" Тогда
			Форма.Элементы[КлючИЗначение.Ключ].Видимость = ТолькоОтгрузка И ЭтоЭлеватор Или ТолькоПеревозка И ЭтоРФ;
		ИначеЕсли КлючИЗначение.Значение.ИмяМетаданных = "ПередачаТоваровХранителю" Тогда
			Форма.Элементы[КлючИЗначение.Ключ].Видимость = ТолькоПеревозка Или Объект.Приемка;
		ИначеЕсли КлючИЗначение.Значение.ИмяМетаданных = "ПередачаТоваровМеждуОрганизациями" Тогда
			Форма.Элементы[КлючИЗначение.Ключ].Видимость = Объект.Реализация;
		ИначеЕсли КлючИЗначение.Значение.ИмяМетаданных = "ВозвратТоваровМеждуОрганизациями" Тогда
			Форма.Элементы[КлючИЗначение.Ключ].Видимость = Объект.Реализация;
		ИначеЕсли КлючИЗначение.Значение.ИмяМетаданных = "ПеремещениеТоваров" Тогда
			Форма.Элементы[КлючИЗначение.Ключ].Видимость = ТолькоПеревозка Или ТолькоПриемкаОтгрузка;
		ИначеЕсли КлючИЗначение.Значение.ИмяМетаданных = "ПоступлениеТоваровОтХранителя" Тогда
			Форма.Элементы[КлючИЗначение.Ключ].Видимость = ТолькоПеревозка Или ТолькоПриемкаОтгрузка;
		ИначеЕсли КлючИЗначение.Значение.ИмяМетаданных = "ВыкупТоваровХранителем" Тогда
			Форма.Элементы[КлючИЗначение.Ключ].Видимость = Объект.Реализация;
		ИначеЕсли КлючИЗначение.Значение.ИмяМетаданных = "ДвижениеПродукцииИМатериалов" Тогда
			Форма.Элементы[КлючИЗначение.Ключ].Видимость = ТолькоПеревозка;
		ИначеЕсли КлючИЗначение.Значение.ИмяМетаданных = "ПоступлениеОтПереработчика" Тогда
			Форма.Элементы[КлючИЗначение.Ключ].Видимость = ТолькоПеревозка;
		ИначеЕсли КлючИЗначение.Значение.ИмяМетаданных = "ВозвратСырьяОтПереработчика" Тогда
			Форма.Элементы[КлючИЗначение.Ключ].Видимость = ТолькоПеревозка;
		ИначеЕсли КлючИЗначение.Значение.ИмяМетаданных = "ПередачаСырьяПереработчику" Тогда
			Форма.Элементы[КлючИЗначение.Ключ].Видимость = ТолькоПеревозка;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ФормированиеПартийЗЕРНО

// Заполняет структуру команд для динамического формирования доступных для создания документов на основании.
// 
// Параметры:
// 	Команды - Структура - Исходящий, структура команд динамически формируемых для создания документов на основании.
//
Процедура КомандыФормированиеПартийЗЕРНО(Команды) Экспорт 
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ВнесениеСведенийОСобранномУрожаеЗЕРНО",  НСтр("ru = 'Внесение сведений о собранном урожае'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ОприходованиеИзлишковТоваров",           НСтр("ru = 'Оприходование излишков товаров'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ПересортицаТоваров",                     НСтр("ru = 'Пересортицу товаров'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ПрочееОприходованиеТоваров",             НСтр("ru = 'Прочее оприходование товаров'"),    "ИспользоватьПрочееОприходованиеТоваров");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ЗаказПоставщику",                        НСтр("ru = 'Заказ поставщику'"),                "ИспользоватьЗаказыПоставщикам");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ПорчаТоваровУХранителя",                 НСтр("ru = 'Порчу товаров у хранителя'"),       "ИспользоватьПорчуТоваровУХранителей,ИспользоватьКачествоТоваров");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ПересортицаТоваровУХранителя",           НСтр("ru = 'Пересортицу товаров у хранителя'"), "ИспользоватьПередачуНаОтветственноеХранениеСПравомПродажи" + ИнтеграцияИСУТКлиентСервер.ИмяФункицональнойОпцииИспользоватьПроизводствоНаСтороне25());
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ОприходованиеИзлишковТоваровУХранителя", НСтр("ru = 'Оприходование излишков товаров у хранителя/комиссионера'"), "ИспользоватьПередачуНаОтветственноеХранениеСПравомПродажи");
//	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(
//		Команды, "ВнесениеСведенийОСобранномУрожаеЗЕРНО", НСтр("ru = 'Внесение сведений о собранном урожае'"));
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды, "ОприходованиеИзлишковТоваров", НСтр("ru = 'Оприходование излишков товаров'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды, "ПрочееОприходованиеТоваров",   НСтр("ru = 'Прочее оприходование товаров'"), "ИспользоватьПрочееОприходованиеТоваров");	

КонецПроцедуры

// Устанавливает видимость команд динамически формируемых для создания документов на основании.
// 
// Параметры:
// 	Форма   - ФормаКлиентскогоПриложения - Форма на которой находятся вызова команд.
// 	Команды - Структура - структура команд динамически формируемых для создания документов на основании.
//
Процедура УправлениеВидимостьюКомандФормированиеПартийЗЕРНО(Форма, Команды) Экспорт
	
	Операция = Форма.Объект.Операция;
	
	Для Каждого КлючИЗначение Из Форма.НастройкиВыполненияПодключаемыхКомандИС.Команды Цикл
		
		ИмяМетаданных = КлючИЗначение.Значение.ИмяМетаданных;
		Элемент       = Форма.Элементы[КлючИЗначение.Ключ];
		
		Если Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийЗЕРНО.ФормированиеПартииПриСбореУрожая")
			Или Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийЗЕРНО.ФормированиеПартииПоРезультатамГосмониторинга") Тогда
			Элемент.Видимость = (ИмяМетаданных = "ВнесениеСведенийОСобранномУрожаеЗЕРНО");
		ИначеЕсли Операция = ПредопределенноеЗначение("Перечисление.ВидыОперацийЗЕРНО.ФормированиеПартииИмпорт") Тогда
			Элемент.Видимость = (ИмяМетаданных = "ЗаказПоставщику");
		ИначеЕсли ИмяМетаданных = "ВнесениеСведенийОСобранномУрожаеЗЕРНО" ИЛИ ИмяМетаданных = "ЗаказПоставщику" Тогда
			Элемент.Видимость = Ложь;
		Иначе
			Элемент.Видимость = Истина;
		КонецЕсли;
		
	КонецЦикла;
		
КонецПроцедуры

#КонецОбласти

#Область СписаниеПартийЗЕРНО

// Заполняет структуру команд для динамического формирования доступных для создания документов на основании.
// 
// Параметры:
// 	Команды - Структура - Исходящий, структура команд динамически формируемых для создания документов на основании.
//
Процедура КомандыСписаниеПартийЗЕРНО(Команды) Экспорт
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,  "ВнутреннееПотребление",           НСтр("ru = 'Внутреннее потребление'"),          "ИспользоватьВнутреннееПотребление");	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,  "ПересортицаТоваров",              НСтр("ru = 'Пересортицу товаров'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,  "ПорчаТоваров",                    НСтр("ru = 'Порчу товаров'"),                   "ИспользоватьКачествоТоваров");	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,  "СписаниеНедостачТоваров",         НСтр("ru = 'Списание недостач товаров'"));
		
		
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,  "ПорчаТоваровУХранителя",          НСтр("ru = 'Порчу товаров у хранителя'"),            "ИспользоватьПорчуТоваровУХранителей,ИспользоватьКачествоТоваров");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,  "ПересортицаТоваровУХранителя",    НСтр("ru = 'Пересортицу товаров у хранителя'"),      "ИспользоватьПередачуНаОтветственноеХранениеСПравомПродажи" + ИнтеграцияИСУТКлиентСервер.ИмяФункицональнойОпцииИспользоватьПроизводствоНаСтороне25());
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,  "ОтчетОСписанииТоваровУХранителя", НСтр("ru = 'Отчет о списании товаров у хранителя'"), "ИспользоватьПередачуНаОтветственноеХранениеСПравомПродажи" + ИнтеграцияИСУТКлиентСервер.ИмяФункицональнойОпцииИспользоватьПроизводствоНаСтороне25());
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды, "ВнутреннееПотребление",           НСтр("ru = 'Внутреннее потребление'"), "ИспользоватьВнутреннееПотребление");	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды, "СписаниеНедостачТоваров",         НСтр("ru = 'Списание недостач товаров'"));
		
КонецПроцедуры

#КонецОбласти

#Область ВнесениеСведенийОСобранномУрожаеЗЕРНО

// Заполняет структуру команд для динамического формирования доступных для создания документов на основании.
// 
// Параметры:
// 	Команды - Структура - Исходящий, структура команд динамически формируемых для создания документов на основании.
//
Процедура КомандыВнесениеСведенийОСобранномУрожаеЗЕРНО(Команды) Экспорт 
	
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ПрочееОприходованиеТоваров",  НСтр("ru = 'Прочее оприходование товаров'"), "ИспользоватьПрочееОприходованиеТоваров");
	
	
	
КонецПроцедуры

#КонецОбласти

#Область ФормированиеПартийПриПроизводствеЗЕРНО

// Заполняет структуру команд для динамического формирования доступных для создания документов на основании.
// 
// Параметры:
// 	Команды - Структура - Исходящий, структура команд динамически формируемых для создания документов на основании.
//
Процедура КомандыФормированиеПартийПриПроизводствеЗЕРНО(Команды) Экспорт 
	
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "СборкаТоваров",         НСтр("ru = 'Сборку (разборку) товаров'"), "ИспользоватьСборкуРазборку");
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды, "СборкаТоваров",        НСтр("ru = 'Сборку (разборку) товаров'"), "ИспользоватьСборкуРазборку");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
