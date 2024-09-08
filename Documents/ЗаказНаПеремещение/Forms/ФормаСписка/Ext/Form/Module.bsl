﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьТекстЗапросаСписка();
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "НачалоТекущегоДня", НачалоДня(ТекущаяДатаСеанса()), Истина);
	
	УстановитьВидимость();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ЗакрытиеЗаказов" Тогда
		Элементы.Список.Обновить();
	КонецЕсли; 
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	
	ОбеспечениеВДокументахКлиент.СписокПриИзменении(ЭтотОбъект, "Документ.ЗаказНаПеремещение.ПустаяСсылка");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды


// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды


&НаКлиенте
Процедура СоздатьЗаказНаВнутреннююПередачуТоваров(Команда)
	
	ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПеремещениеТоваровМеждуФилиалами");
	
	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("Основание", Новый Структура("ХозяйственнаяОперация", ХозяйственнаяОперация));
	ОткрытьФорму("Документ.ЗаказНаПеремещение.ФормаОбъекта", СтруктураПараметры, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусЗакрыт(Команда)
	
	ВыделенныеСсылки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	
	Если ВыделенныеСсылки.Количество() = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	СтруктураЗакрытия = Новый Структура;
	СписокЗаказов = Новый СписокЗначений;
	СписокЗаказов.ЗагрузитьЗначения(ВыделенныеСсылки);
	СтруктураЗакрытия.Вставить("Заказы",                       СписокЗаказов);
	СтруктураЗакрытия.Вставить("ОтменитьНеотработанныеСтроки", Истина);
	СтруктураЗакрытия.Вставить("ЗакрыватьЗаказы",              Истина);
	
	ОткрытьФорму("Обработка.ПомощникЗакрытияЗаказов.Форма.ФормаЗакрытия", СтруктураЗакрытия,
					ЭтаФорма,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКВыполнению(Команда)
	
	ВыделенныеСсылки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	
	Если ВыделенныеСсылки.Количество() = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке заказов будет установлен статус ""К выполнению"". Продолжить?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусКВыполнениюЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСсылки", ВыделенныеСсылки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКВыполнениюЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСсылки = ДополнительныеПараметры.ВыделенныеСсылки;
    
    
    Ответ = РезультатВопроса;
    
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        
        Возврат;
        
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделенныеСсылки, "КВыполнению");
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСсылки.Количество(),
    НСтр("ru = 'К выполнению'"));

КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьТекстЗапросаСписка()
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	ЗаполнитьЗначенияСвойств(СвойстваСписка, Список);
	
	Если ПравоДоступа("Чтение", Метаданные.РегистрыСведений.СостоянияВнутреннихЗаказов) Тогда
		
		СвойстваСписка.ТекстЗапроса =
		"ВЫБРАТЬ
		|	ДокументЗаказНаПеремещение.Ссылка,
		|	ДокументЗаказНаПеремещение.ПометкаУдаления,
		|	ДокументЗаказНаПеремещение.Номер,
		|	ДокументЗаказНаПеремещение.Дата,
		|	ДокументЗаказНаПеремещение.Проведен,
		|	ДокументЗаказНаПеремещение.ДлительностьПеремещения,
		|	ДокументЗаказНаПеремещение.ЖелаемаяДатаПоступления,
		|	ДокументЗаказНаПеремещение.Комментарий,
		|	ДокументЗаказНаПеремещение.МаксимальныйКодСтроки,
		|	ДокументЗаказНаПеремещение.Организация,
		|	ДокументЗаказНаПеремещение.ОрганизацияПолучатель,
		|	ДокументЗаказНаПеремещение.Ответственный,
		|	ДокументЗаказНаПеремещение.Подразделение,
		|	ДокументЗаказНаПеремещение.Сделка,
		|	ДокументЗаказНаПеремещение.СкладОтправитель,
		|	ДокументЗаказНаПеремещение.СкладПолучатель,
		|	ДокументЗаказНаПеремещение.Статус,
		|	ДокументЗаказНаПеремещение.Приоритет,
		|	ДокументЗаказНаПеремещение.ХозяйственнаяОперация,
		|	ДокументЗаказНаПеремещение.Назначение,
		|	ДокументЗаказНаПеремещение.ДокументОснование,
		|	ДокументЗаказНаПеремещение.СостояниеЗаполненияМногооборотнойТары,
		|	ДокументЗаказНаПеремещение.МоментВремени,
		|	ДокументЗаказНаПеремещение.Автор,
		|	ВЫБОР
		|		КОГДА НЕ ДокументЗаказНаПеремещение.Проведен
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СостоянияВнутреннихЗаказов.ПустаяСсылка)
		|		ИНАЧЕ ЕСТЬNULL(СостоянияВнутреннихЗаказов.Состояние, ЗНАЧЕНИЕ(Перечисление.СостоянияВнутреннихЗаказов.Закрыт))
		|	КОНЕЦ КАК Состояние,
		|	ЕСТЬNULL(СостоянияВнутреннихЗаказов.ЕстьРасхожденияОрдерНакладная, ЛОЖЬ) КАК ЕстьРасхожденияОрдерНакладная
		|ИЗ
		|	Документ.ЗаказНаПеремещение КАК ДокументЗаказНаПеремещение
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияВнутреннихЗаказов КАК СостоянияВнутреннихЗаказов
		|		ПО (СостоянияВнутреннихЗаказов.Заказ = ДокументЗаказНаПеремещение.Ссылка)";
		
	Иначе
		
		СвойстваСписка.ТекстЗапроса =
		"ВЫБРАТЬ
		|	ДокументЗаказНаПеремещение.Ссылка,
		|	ДокументЗаказНаПеремещение.ПометкаУдаления,
		|	ДокументЗаказНаПеремещение.Номер,
		|	ДокументЗаказНаПеремещение.Дата,
		|	ДокументЗаказНаПеремещение.Проведен,
		|	ДокументЗаказНаПеремещение.ДлительностьПеремещения,
		|	ДокументЗаказНаПеремещение.ЖелаемаяДатаПоступления,
		|	ДокументЗаказНаПеремещение.Комментарий,
		|	ДокументЗаказНаПеремещение.МаксимальныйКодСтроки,
		|	ДокументЗаказНаПеремещение.Организация,
		|	ДокументЗаказНаПеремещение.ОрганизацияПолучатель,
		|	ДокументЗаказНаПеремещение.Ответственный,
		|	ДокументЗаказНаПеремещение.Подразделение,
		|	ДокументЗаказНаПеремещение.Сделка,
		|	ДокументЗаказНаПеремещение.СкладОтправитель,
		|	ДокументЗаказНаПеремещение.СкладПолучатель,
		|	ДокументЗаказНаПеремещение.Статус,
		|	ДокументЗаказНаПеремещение.Приоритет,
		|	ДокументЗаказНаПеремещение.ХозяйственнаяОперация,
		|	ДокументЗаказНаПеремещение.Назначение,
		|	ДокументЗаказНаПеремещение.ДокументОснование,
		|	ДокументЗаказНаПеремещение.СостояниеЗаполненияМногооборотнойТары,
		|	ДокументЗаказНаПеремещение.Автор,
		|	ДокументЗаказНаПеремещение.МоментВремени
		|ИЗ
		|	Документ.ЗаказНаПеремещение КАК ДокументЗаказНаПеремещение";
		
	КонецЕсли;
	
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, СвойстваСписка);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	ЕстьДоступНаИзменение = ПравоДоступа("Изменение", Метаданные.Документы.ЗаказНаПеремещение);
	ПравоДоступаДобавление = Документы.ЗаказНаПеремещение.ПравоДоступаДобавление();
	
	ИспользоватьРасширенноеОбеспечениеПотребностей = ПолучитьФункциональнуюОпцию("ИспользоватьРасширенноеОбеспечениеПотребностей");
	ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс = ПолучитьФункциональнуюОпцию("ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс");
	
	ЕстьКомандаСозданияПоПотребностям = ПравоДоступаДобавление И ИспользоватьРасширенноеОбеспечениеПотребностей;
	ЕстьКомандаСозданияВнутреннейПередачи = ПравоДоступаДобавление И ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс;
	ЕcтьГруппаКомандСоздания = ЕстьКомандаСозданияПоПотребностям Или ЕстьКомандаСозданияВнутреннейПередачи;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаСоздать", "Видимость",
		Не ЕcтьГруппаКомандСоздания);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
		"СписокСоздать",
		"Видимость",
		ЕcтьГруппаКомандСоздания И Не ЕстьКомандаСозданияВнутреннейПередачи);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
		"СоздатьЗаказНаПеремещениеТоваров",
		"Видимость",
		ЕстьКомандаСозданияВнутреннейПередачи);
	Элементы.СоздатьЗаказНаВнутреннююПередачуТоваров.Видимость = ЕстьКомандаСозданияВнутреннейПередачи;
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
		"ФормаОбщаяКомандаФормированиеЗаказовНаПеремещениеПоПотребностям",
		"Видимость",
		ЕстьКомандаСозданияПоПотребностям);
	
	Элементы.УстановитьСтатусКВыполнению.Видимость = ЕстьДоступНаИзменение
		И Документы.ЗаказНаПеремещение.ИспользоватьСтатусы();
	Элементы.УстановитьСтатусЗакрыт.Видимость = ЕстьДоступНаИзменение
		И ПолучитьФункциональнуюОпцию("НеЗакрыватьЗаказыНаПеремещениеБезПолнойОтгрузки");
	
	Элементы.СписокОтгрузитьЗаказ.Видимость = ЕстьДоступНаИзменение;
	Элементы.СписокРезервироватьЗаказ.Видимость = ЕстьДоступНаИзменение;
	Элементы.СписокКОбеспечениюЗаказ.Видимость = ЕстьДоступНаИзменение;
	Элементы.СписокРезервироватьПоМереПоступленияЗаказ.Видимость = ЕстьДоступНаИзменение;
	Элементы.СписокНеОбеспечиватьЗаказ.Видимость = ЕстьДоступНаИзменение;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗаданияРаспределенияЗапасовПоЗаказам()
	ОбеспечениеВДокументахКлиент.ПроверитьВыполнениеЗаданияРаспределенияЗапасовПоЗаказам(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

#КонецОбласти

#Область Производительность

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.ЗаказНаПеремещение.ФормаСписка.Элемент.Список.Выбор");
	
КонецПроцедуры

#КонецОбласти
